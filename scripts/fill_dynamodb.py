"""Fills the DynamoDB table with the sample data."""

import os
import datetime

import click
import pandas as pd
import boto3
from tqdm import tqdm

DYNAMODB_TABLE_NAME = "real-time-wine-vat-data"


@click.command()
@click.option("-n", "--entries", type=int, default=200)
@click.option("--profile", default="default")
def main(entries, profile):
    try:
        session = boto3.Session(profile_name=profile)

        df = load_data(fpath=os.path.join(os.getcwd(), "data", "full.csv"))
        data = format_dataframe(df, n=entries)

        push_data_to_dynamodb(data, session=session)
    except KeyboardInterrupt as e:
        print("Stopping data push...")
    finally:
        log_results(session=session)
    return


def load_data(fpath):
    df = pd.read_csv(fpath, sep=";")
    df.index.rename("vatID", inplace=True)
    df.reset_index(inplace=True)
    df = df.astype("str")
    df.vatID = pd.util.hash_array(df.vatID).astype("str")
    return df


def format_dataframe(df, n):
    rows = df.shape[0]
    dff = df.sample(min(n, rows))  # Either get entire df or get n.
    return dff.to_dict(orient="records")


def push_data_to_dynamodb(data, session):
    dynamodb = session.resource("dynamodb")
    table = dynamodb.Table(DYNAMODB_TABLE_NAME)

    with table.batch_writer() as batch:
        for entry in tqdm(data):
            batch.put_item(Item=entry)
    return


def log_results(session):
    dynamodb = session.resource("dynamodb")
    table = dynamodb.Table(DYNAMODB_TABLE_NAME)

    scan_results = table.scan(Select="COUNT")

    print("\n== RESULTS ==")
    print(f"Current total entries in table: {scan_results['Count']}")
    return


if __name__ == "__main__":
    main()

"""Fills the DynamoDB table with the sample data."""

import os
import datetime

import click
import pandas as pd
import boto3
from tqdm import tqdm

DYNAMODB_TABLE_NAME = 'real-time-wine-vat-data'


@click.command()
@click.option('--amount', type=str, default='small')
def main(amount):
    try:
        df = load_data(fpath=os.path.join(os.getcwd(), 'data', f'{amount}.csv'))
        data = format_dataframe(df)
        push_data_to_dynamodb(data)
    except KeyboardInterrupt as e:
        print("Stopping data push...")
    finally:
        log_results()
    return


def load_data(fpath):
    df = pd.read_csv(fpath, sep=';')
    df.index.rename('vatID', inplace=True)
    df.reset_index(inplace=True)
    df = df.astype('str')
    df.vatID = pd.util.hash_array(df.vatID).astype('str')
    return df


def format_dataframe(df):
    return df.to_dict(orient='records')


def push_data_to_dynamodb(data):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(DYNAMODB_TABLE_NAME)

    with table.batch_writer() as batch:
        for entry in tqdm(data):
            batch.put_item(
                Item = entry
            )
    return


def log_results():
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(DYNAMODB_TABLE_NAME)

    scan_results = table.scan(
        Select = "COUNT",
    )

    print(f"Entries in table: {scan_results['Count']}")
    return


if __name__ == "__main__":
    main()
import boto3
import pandas as pd
from tqdm import tqdm


def fill_database(table, sample_path):
    df = load_data(sample_path)
    data = format_dataframe(df)
    push_data_to_dynamodb(table, data)
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


def push_data_to_dynamodb(table, data):
    dynamodb = boto3.resource('dynamodb')
    tbl = dynamodb.Table(table)

    with tbl.batch_writer() as batch:
        for entry in tqdm(data):
            batch.put_item(
                Item = entry
            )
    return
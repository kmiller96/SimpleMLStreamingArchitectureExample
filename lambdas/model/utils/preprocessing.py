import json

import pandas as pd


def load_dataframe_from_sqs(event):
    rows = [json.loads(message["body"]) for message in event["Records"]]
    df = pd.DataFrame.from_records(rows)
    df.set_index('vatID', inplace=True)
    df.drop('quality', axis="columns", errors='ignore', inplace=True)
    return df


def preprocess(df):
    """Runs initial model preprocessing in preparation for training/inference."""
    return df  # For the moment do nothing.


def Xy_split(df):
    X, y = df.drop("quality", axis=1), df.quality
    return X, y

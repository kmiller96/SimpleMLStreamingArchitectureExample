import pandas as pd


def preprocess(df):
    """Runs initial model preprocessing in preparation for training/inference."""
    return df  # For the moment do nothing.


def Xy_split(df):
    X, y = df.drop("quality", axis=1), df.quality
    return X, y

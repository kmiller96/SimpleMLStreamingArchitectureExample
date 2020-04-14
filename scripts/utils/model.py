"""Defines the wine quality as a generic wrapper. Abstracts away model specifics."""

import re
import tempfile

import boto3
import joblib
import xgboost
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score


def root_mean_squared_error(y_actual, y_predicted, **kwargs):
    return mean_squared_error(y_actual, y_predicted, **kwargs) ** 0.5


def split_s3_uri(path):
    bucket, key = re.match(r"s3:\/\/(.+?)\/(.+)", path).groups()
    return bucket, key


class WineQualityModel:
    model_defaults = dict(objective="reg:squarederror")

    def __init__(self, **kwargs):
        hyperparameters = {**self.model_defaults, **kwargs}
        self._model = xgboost.XGBRegressor(**hyperparameters)

    def fit(self, X, y):
        self._model.fit(X, y)
        return self

    def predict(self, X):
        y = self._model.predict(X)
        return y

    def evaluate(self, X, y):
        y_hat = self.predict(X)
        results_dict = {
            "mae": mean_absolute_error(y, y_hat),
            "rmse": root_mean_squared_error(y, y_hat),
            "r2": r2_score(y, y_hat),
        }
        return results_dict

    def save(self, path):
        s3 = boto3.client("s3")

        with tempfile.TemporaryFile() as fp:
            joblib.dump(self._model, fp)

            fp.seek(0)

            bucket, key = split_s3_uri(path)
            s3.upload_fileobj(fp, bucket, key)
        return self

    def load(self, path):
        s3 = boto3.client("s3")

        with tempfile.TemporaryFile() as fp:
            bucket, key = split_s3_uri(path)
            s3.download_fileobj(bucket, key, fp)

            fp.seek(0)

            self._model = joblib.load(fp)
        return self

"""Trains the wine quality model."""

import click
import pandas as pd
from tqdm import tqdm

from utils.kfold import kfold
from utils.model import WineQualityModel
from utils.preprocessing import preprocess, Xy_split

S3_PATH = "s3://kalemiller-model-artifacts/real-time-wine/model.joblib"


@click.command()
@click.argument("data", type=click.Path(exists=True))
@click.option("--k-folds", type=int, default=10)
def main(data, k_folds):
    """Trains a new ML model and uploads it to S3."""
    df = pd.read_csv(data, sep=";")
    df = preprocess(df)

    results = cross_validate_performance(df=df, n=k_folds)
    avg_results = average_evaluation_metrics(results)

    print(f"== Model Evaluation Results (Folds: {k_folds}) ==")
    for metric, value in avg_results.items():
        print(f"{metric.upper()}: {value}")
    print(f"=================================================")

    X, y = Xy_split(df)
    model = WineQualityModel()
    model.fit(X, y)
    model.save(path=S3_PATH)

    return


def cross_validate_performance(df, n=5):
    results = []

    pbar = tqdm
    for X_train, y_train, X_test, y_test in kfold(df, n=n):
        model = WineQualityModel()
        model.fit(X_train, y_train)
        fold_results = model.evaluate(X_test, y_test)

        results.append(fold_results)

    return results


def average_evaluation_metrics(results):
    n_folds = len(results)
    metrics = results[0].keys()

    averages = {}
    for metric_key in metrics:
        total = sum([fold[metric_key] for fold in results])
        avg = total / n_folds
        averages[metric_key] = avg

    return averages


if __name__ == "__main__":
    main()

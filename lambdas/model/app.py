"""Makes predictions on the current wine quality."""

import os

import boto3

from . import utils

OUTPUT_QUEUE_URL = os.environ["OUTPUT_QUEUE_URL"]
MODEL_PATH = os.environ["MODEL_PATH"]

sqs = boto3.client('sqs')


def training(event, context=None):
    raise NotImplementedError(
        "You can't train in the cloud at the moment. "
        "Please run the `make train` command in the source code to train locally instead."
    )
    return 200


def inference(event, context=None):
    df = utils.load_dataframe_from_sqs(event)
    X = utils.preprocess(df)

    model = utils.WineQualityModel().load(path=MODEL_PATH)
    y_hat = model.predict(X=df)

    responses = []
    for row in y_hat.to_dict(orient='records'):
        message = utils.format_message(row)
        response = sqs.send_message(QueueUrl=OUTPUT_QUEUE_URL, MessageBody=message)
        responses.append(response)

    return {"Status": 200, "Records": responses}

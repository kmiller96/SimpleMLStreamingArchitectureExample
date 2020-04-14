"""Pulls changed items from DynamoDB table and pushes them into a queue."""
import boto3
import os

from . import utils

QUEUE_URL = os.environ["QUEUE_URL"]

sqs = boto3.client("sqs")


def lambda_handler(event, context=None):
    table_items = utils.parse_dynamodb_event(event)

    responses = []
    for item in table_items:
        queue_message = utils.format_message(item)
        response = sqs.send_message(QueueUrl=QUEUE_URL, MessageBody=queue_message,)
        responses.append(response)

    return {"Status": 200, "Records": responses}

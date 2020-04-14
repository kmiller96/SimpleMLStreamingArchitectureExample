"""Grabs entries from SQS queue and pushes them into DynamoDB."""

import boto3
import os

from . import utils

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["DYNAMODB_TABLE_NAME"])


def lambda_handler(event, context=None):
    entries = utils.parse_sqs_event(event)

    with table.batch_writer() as batch:
        for entry in entries:
            item = utils.format_dynamodb_key(entry)
            batch.put_item(Item=item)
    return 200

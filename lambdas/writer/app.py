"""Grabs entries from SQS queue and pushes them into DynamoDB."""

import os

import boto3

DYNAMODB_TABLE_NAME = os.environ['DYNAMODB_TABLE_NAME']

dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):
    entries = utils.parse_sqs_event(event)

    for entry in entries:
        item = utils.format_dynamodb_key(entry) 
        dynamodb.update_item(
            TableName = DYNAMODB_TABLE_NAME,
            Key = item 
        )
    return 200
import pytest

import boto3
import os

from lambdas.fixtures import *


def test_parse_sqs_event(sqs):
    from lambdas.writer.utils import parse_sqs_event
    entries = parse_sqs_event(sqs)

    assert len(entries) == 2
    assert entries[0].keys() == entries[1].keys()


def test_format_dynamodb_key(sqs):
    from lambdas.writer.utils import parse_sqs_event, format_dynamodb_key
    entries = parse_sqs_event(sqs)
    items = [format_dynamodb_key(x) for x in entries]

    assert all(['vatID' in x for x in items]) 


def test_normal_event(writer_lambda_runtime, sqs):
    from lambdas.writer.app import lambda_handler  # TODO: Migrate this to root level for tests.

    lambda_handler(event=sqs)

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(os.environ['DYNAMODB_TABLE_NAME'])

    assert table.get_item(Key = {
        'vatID': "10"
    })
    assert table.get_item(Key = {
        'vatID': "11"
    })
import pytest

from lambdas.fixtures import *


def test_parse_sqs_event(sqs):
    from lambdas.writer.utils import parse_sqs_event
    entries = parse_sqs_event(sqs)

    assert len(entries) == 2
    assert entries[0] == entries[1]


def test_format_dynamodb_key(sqs):
    from lambdas.writer.utils import parse_sqs_event, format_dynamodb_key
    entries = parse_sqs_event(sqs)
    items = [format_dynamodb_key(x) for x in entries]

    assert all(['vatID' in x for x in items]) 
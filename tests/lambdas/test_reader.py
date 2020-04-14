import pytest

from lambdas.fixtures import *


def test_normal_event(reader_lambda_runtime, dynamodb):
    """Assert that the handler runs without throwing an exception."""
    from lambdas.reader.app import lambda_handler

    response = lambda_handler(event=dynamodb)
    return

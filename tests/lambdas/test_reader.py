import pytest

from lambdas.fixtures import *


def test_normal_event(reader_lambda_runtime, dynamodb):
    from lambdas.reader.app import lambda_handler  # TODO: Migrate this to root level for tests.

    lambda_handler(event=dynamodb)
    return
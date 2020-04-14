import pytest

from lambdas.fixtures import *


def test_normal_event(reader_lambda_runtime, sqs):
    from lambdas.model.app import training 

    training(event=sqs)
    return
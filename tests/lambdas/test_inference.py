import pytest

from lambdas.fixtures import *


def test_normal_event(model_lambda_runtime, sqs):
    from lambdas.model.app import inference

    inference(event=sqs)
    return
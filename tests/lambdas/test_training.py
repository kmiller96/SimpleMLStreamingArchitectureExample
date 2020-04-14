import pytest

from lambdas.fixtures import *


@pytest.mark.skip
def test_normal_event(model_lambda_runtime, sqs):
    from lambdas.model.app import training 

    training(event=sqs)
    return
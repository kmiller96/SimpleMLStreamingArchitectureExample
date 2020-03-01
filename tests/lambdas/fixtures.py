import pytest 

import json
import os

from python_terraform import Terraform
tf = Terraform(working_dir='infrastructure/')
stack = tf.output()


@pytest.fixture
def reader_lambda_runtime():
    os.environ['QUEUE_URL'] = stack['reader_queue_url']['value']
    yield
    del os.environ['QUEUE_URL']


@pytest.fixture
def dynamodb():
    with open('tests/lambdas/events/dynamodb.json', 'r') as f:
        return json.load(f)


@pytest.fixture
def sqs():
    with open('tests/lambdas/events/sqs.json', 'r') as f:
        return json.load(f)
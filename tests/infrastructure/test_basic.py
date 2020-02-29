import pytest

import boto3

from infrastructure.fixtures import *


@pytest.mark.slow
def test_terraform(infrastructure):
    ...
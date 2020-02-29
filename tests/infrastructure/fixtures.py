import pytest

DYNAMODB_NAME = "real-time-wine-vat-data"


@pytest.fixture
def infrastructure():
    return {
        'table': DYNAMODB_NAME,
    }

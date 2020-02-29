import pytest

from infrastructure.utils import database

@pytest.fixture
def infrastructure(data: bool):
    """Stands up a fresh copy of the Terraform infrastructure to work with."""
    ...
    if data:
        fill_database(db, sample_path="../test-data/small.csv")
    ...
    raise NotImplementedError()


@pytest.fixture
def data():
    """Fills the DynamoDB database with dummy data."""
    raise NotImplementedError()
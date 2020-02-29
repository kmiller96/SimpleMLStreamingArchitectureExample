import pytest

from python_terraform import Terraform

from infrastructure.utils import database

tf = Terraform(working_dir='infrastructure/')

@pytest.fixture
def infrastructure(data: bool = True):
    """Stands up a fresh copy of the Terraform infrastructure to work with."""
    tf.apply()
    if data:
        fill_database(db, sample_path="../test-data/small.csv")
    
    yield tf

    tf.destroy()
    return 

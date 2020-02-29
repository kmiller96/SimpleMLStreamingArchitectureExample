import pytest
from python_terraform import Terraform

DYNAMODB_NAME = "real-time-wine-vat-data"

from infrastructure import utils 
tf = Terraform(working_dir='infrastructure/')

@pytest.fixture(scope="session")
def infrastructure(data: bool = True):
    """Stands up a fresh copy of the Terraform infrastructure to work with."""
    tf.apply()
    if data:
        utils.fill_database(table=DYNAMODB_NAME, sample_path="./data/small.csv")
    
    yield tf

    tf.destroy()
    return 

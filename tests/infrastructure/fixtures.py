import pytest

from python_terraform import Terraform

from infrastructure import utils 

tf = Terraform(working_dir='infrastructure/')

@pytest.fixture(scope="session")
def infrastructure(data: bool = True):
    """Stands up a fresh copy of the Terraform infrastructure to work with."""
    db = ''  # TODO: Figure out the DB value.

    tf.apply()
    if data:
        utils.fill_database(db, sample_path="../../data/small.csv")
    
    yield tf

    tf.destroy()
    return 

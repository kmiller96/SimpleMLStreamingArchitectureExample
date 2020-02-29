import pytest

from infrastructure.fixtures import *


@pytest.mark.slow
def test_terraform(infrastructure):
    return
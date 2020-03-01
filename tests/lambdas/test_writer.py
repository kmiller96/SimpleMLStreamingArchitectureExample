import pytest

from lambdas.fixtures import *


def test_parse_sqs_event(sqs):
    from lambdas.writer.utils import parse_sqs_event
    entries = parse_sqs_event(sqs)

    assert len(entries) == 2
    assert entries[0] == entries[1]
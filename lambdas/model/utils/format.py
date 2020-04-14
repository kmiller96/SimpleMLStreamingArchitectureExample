import json


def format_message(item):
    return json.dumps(item, sort_keys=True)

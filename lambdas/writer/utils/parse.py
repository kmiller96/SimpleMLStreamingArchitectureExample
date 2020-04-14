import json


def parse_sqs_event(event):
    rows = []

    for record in event["Records"]:
        message = record["body"]
        row = json.loads(message)
        rows.append(row)

    return rows

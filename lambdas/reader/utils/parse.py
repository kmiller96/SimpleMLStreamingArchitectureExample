def parse_dynamodb_event(event):
    items = []

    for record in event["Records"]:
        dynamodb_item = record["dynamodb"]["NewImage"]
        pandas_item = dynamodb_to_pandas(dynamodb_item)
        items.append(pandas_item)

    return items


def dynamodb_to_pandas(item):
    pandas_row = {
        col: (r.get("S") or r.get("N") or r.get("B")) for col, r in item.items()
    }
    return pandas_row

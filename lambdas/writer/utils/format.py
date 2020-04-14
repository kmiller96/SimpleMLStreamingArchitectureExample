def format_dynamodb_key(entry):
    """Converts from Pandas format to DynamoDB format."""
    item = {k: str(v) for k, v in entry.items()}
    return item

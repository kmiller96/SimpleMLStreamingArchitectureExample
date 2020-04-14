from datetime import datetime
import time


def format_dynamodb_key(entry):
    """Converts from Pandas format to DynamoDB format."""
    item = {k: str(v) for k, v in entry.items()}

    item["timestamp_in_seconds"] = time.time()
    item["inference_date"] = datetime.utcnow().strftime("%Y%m%d_%H%M%S")
    return item

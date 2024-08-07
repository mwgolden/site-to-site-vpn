import json

def lambda_handler(event, context):
    query_params = event.get('queryStringParameters', {})
    print(query_params)
    return {
        "statusCode": 200,
        "body": json.dumps({"query_params":query_params})
    }
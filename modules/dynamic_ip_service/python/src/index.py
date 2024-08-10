import json
import os
import boto3

def save_to_bucket(bucket, key, json_object):
    s3 = boto3.resource("s3")
    obj = s3.Object(Bucket=bucket, Key=key)
    response = obj.put(Body=json.dumps(json_object))
    return response

def get_from_bucket(bucket, key):
    s3 = boto3.client('s3')
    file_obj = s3.get_object(Bucket=bucket,Key=key)
    fileData = file_obj['Body'].read()
    return json.loads(fileData)

def lambda_handler(event, context):
    s3_bucket = os.environ.get('BUCKET')
    s3_key = os.environ.get('BUCKET_KEY')
    query_params = event.get('queryStringParameters', {})
    current_ip = os.environ.get('IP_ADDRESS')
    new_ip = query_params.get('myip')

    print(f'current ip: {current_ip}')
    print(f'new ip: {new_ip}')

    print(message)
    return {
        "statusCode": 200,
        "body": json.dumps({"message":message})
    }
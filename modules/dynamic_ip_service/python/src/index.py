import json
import os
import boto3
from datetime import datetime

def save_to_bucket(bucket, key, json_object):
    s3 = boto3.resource("s3")
    try:
        obj = s3.Object(bucket, key)
        response = obj.put(Body=json.dumps(json_object))
        return response
    except Exception as e:
        print(e)
        return None


def get_from_bucket(bucket, key):
    s3 = boto3.client('s3')
    try:
        file_obj = s3.get_object(Bucket=bucket,Key=key)
        fileData = file_obj['Body'].read()
        return json.loads(fileData)
    except Exception as e:
        print(e)
        return None
    
    
def publish_event(message):
    print(message)
    eb = boto3.client('events')
    response = eb.put_events(Entries=[message])
    if response.get('FailedEntryCount') > 0:
        raise Exception(f"Eventbridge Error: {json.dumps(response['Entries'])}")


def lambda_handler(event, context):
    s3_bucket = os.environ.get('BUCKET')
    s3_key = os.environ.get('BUCKET_KEY')
    query_params = event.get('queryStringParameters', {})
    current_ip = get_from_bucket(s3_bucket, s3_key)
    new_ip = query_params.get('myip')

    print(f'current ip: {current_ip}')
    print(f'new ip: {new_ip}')

    message = ''
    if not current_ip or current_ip.get('myip') != new_ip:
        save_to_bucket(s3_bucket, s3_key, query_params)
        response = publish_event({
            'Source': 'dynamic.ip.service',
            'Detail': json.dumps(
                {
                    'ipaddress': new_ip,
                    'local_cidr': "192.168.1.0/24",
                    "network_cidr": "10.0.0.0/16" 
                }),
            'DetailType': 'dynamic.ip.service'
        })
        print(response)
        message = f"IP address updated to {new_ip}"
    else:
        message = "IP Address has not changed"

    print(message)
    return {
        "statusCode": 200,
        "body": json.dumps({"message":message})
    }
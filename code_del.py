import boto3
import os

def handler(event, context):
    # Get the bucket name from an environment variable or event
    bucket_name = os.environ['BUCKET_NAME']  # or event['bucket_name']

    s3 = boto3.client('s3')

    try:
        # List all objects in the bucket
        objects_to_delete = s3.list_objects_v2(Bucket=bucket_name)

        if 'Contents' in objects_to_delete:
            # Prepare a list of objects to delete
            delete_keys = [{'Key': obj['Key']} for obj in objects_to_delete['Contents']]
            
            # Delete all objects
            response = s3.delete_objects(
                Bucket=bucket_name,
                Delete={
                    'Objects': delete_keys
                }
            )

            return {
                'statusCode': 200,
                'body': f"Deleted {len(delete_keys)} objects from bucket {bucket_name}."
            }
        else:
            return {
                'statusCode': 200,
                'body': f"No objects found in bucket {bucket_name}."
            }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': str(e)
        }

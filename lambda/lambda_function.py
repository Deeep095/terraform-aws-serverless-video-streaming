import boto3
import os
import json

def lambda_handler(event, context):
    print("Event:", json.dumps(event))

    # Get the region from the AWS Lambda environment variable
    region = os.environ.get('AWS_REGION')
    
    # --- CORRECTION #1: Fix the TypeError ---
    # The describe_endpoints() response contains a list of Endpoints. We must
    # access the first item  in the list to get the URL.
    mediaconvert_discovery_client = boto3.client('mediaconvert', region_name=region)
    endpoints = mediaconvert_discovery_client.describe_endpoints(MaxResults=1)
    endpoint_url = endpoints['Endpoints']['Url']
    
    # Create the final client using the discovered endpoint
    mediaconvert_client = boto3.client('mediaconvert', region_name=region, endpoint_url=endpoint_url)
    
    input_bucket = os.environ
    output_bucket = os.environ
    mediaconvert_role = os.environ

    # Get the uploaded file path from the S3 event
    record = event
    key = record["s3"]["object"]["key"]
    input_path = f"s3://{input_bucket}/{key}"
    
    # Create a clean output path by removing the file extension from the key
    output_key_prefix = os.path.splitext(key)
    job_output = f"s3://{output_bucket}/{output_key_prefix}/"

    job_settings = {
        "Role": mediaconvert_role,
        "Settings": {
            "Inputs": [{"FileInput": input_path}],
            "OutputGroups":[{
                "Type": "HLS_GROUP_SETTINGS",
                    "HlsGroupSettings": {
                        "Destination": job_output,
                        "SegmentLength": 5
                    }
            }
            ]
            }
        }

    try:
        response = mediaconvert_client.create_job(**job_settings)
        print("MediaConvert job created:", response["Job"]["Id"])
    except Exception as e:
        print("Error:", str(e))
        raise

    return {"statusCode": 200, "body": "Job started"}

# def lambda_handler(event, context):
#     print("Event:", json.dumps(event))
#     mediaconvert_client = boto3.client("mediaconvert", region_name=boto3.session.Session().region_name)
#     mediaconvert_discovery_client = boto3.client('mediaconvert',region_name=boto3.session.Session().region_name)
#     endpoints = mediaconvert_discovery_client.describe_endpoints(MaxResults=1)
#     endpoint_url = endpoints['Endpoints']['Url']
#     mediaconvert_client = boto3.client('mediaconvert', region_name=boto3.session.Session().region_name, endpoint_url=endpoint_url)
    
#     input_bucket  = os.environ["INPUT_BUCKET"]
#     print("Input bucket:", input_bucket)
#     output_bucket = os.environ["OUTPUT_BUCKET"]
#     mediaconvert_role = os.environ["MEDIACONVERT_ROLE"]
#     print("mediaconvert role:", mediaconvert_role)

#     # get the uploaded file path
#     record = event["Records"][0]
#     key = record["s3"]["object"]["key"]
#     input_path = f"s3://{input_bucket}/{key}"
#     print("Input file:", input_path)

#     output_key = os.path.splitext(key)
#     # print("Output prefix:", output_key)
#     job_output = f"s3://{output_bucket}/{output_key}/"
#     print("Job output:", job_output)

#     job_settings = {
#         "Role": mediaconvert_role,
#         "Settings": {
#             "Inputs": [{"FileInput": input_path}],
#             "OutputGroups":[{
#                 "Type": "HLS_GROUP_SETTINGS",
#                     "HlsGroupSettings": {
#                         "Destination": job_output,
#                         "SegmentLength": 5
#                     }
#             }
#             ]
#             }
#         }
    
#     # job_settings = {
#     #     "Role": mediaconvert_role,
#     #     "Settings": {
#     #         "Inputs": [{"FileInput": input_path}],
#     #         "OutputGroups": [{
#     #             "Name": "HLS",
#     #             "OutputGroupSettings": {
#     #                 "Type": "HLS_GROUP_SETTINGS",
#     #                 "HlsGroupSettings": {
#     #                     "Destination": job_output,
#     #                     "SegmentLength": 5
#     #                 }
#     #             },
#     #             "Outputs": [
#     #                 {"Preset": "System-Ott_Hls_Ts_Avc_Aac_16x9_1280x720p_30Hz_5.0Mbps",
#     #                  "NameModifier": "_720p"},
#     #                 {"Preset": "System-Ott_Hls_Ts_Avc_Aac_16x9_854x480p_30Hz_2.5Mbps",
#     #                  "NameModifier": "_480p"},
#     #                 {"Preset": "System-Ott_Hls_Ts_Avc_Aac_16x9_640x360p_30Hz_1.2Mbps",
#     #                  "NameModifier": "_360p"}
#     #             ]
#     #         }]
#     #     }
#     # }

#     try:
#         response = mediaconvert_client.create_job(**job_settings)
#         print("MediaConvert job created:", response["Job"]["Id"])
#     except Exception as e:
#         print("Error:", str(e))
#         raise

#     return {"statusCode": 200, "body": "Job started"}

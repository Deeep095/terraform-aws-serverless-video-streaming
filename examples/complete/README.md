# Complete Example - Serverless Video Streaming

This example demonstrates how to deploy a complete serverless video streaming infrastructure using AWS services.

## Architecture


┌─────────────┐     ┌──────────┐     ┌──────────────┐     ┌─────────────┐
│   Upload    │────▶│  Lambda  │────▶│ MediaConvert │────▶│   Output    │
│  S3 Bucket  │     │ Function │     │    (HLS)     │     │  S3 Bucket  │
└─────────────┘     └──────────┘     └──────────────┘     └─────────────┘
     │                                                           │
     └───────────────── S3 Event Trigger ─────────────────────────


# Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0.0
- AWS account with permissions for S3, Lambda, IAM, and MediaConvert

## Usage

1. **Initialize Terraform:**

   ```bash
   terraform init
   ```

2. **Review the execution plan:**

   ```bash
   terraform plan
   ```

3. **Apply the configuration:**

   ```bash
   terraform apply
   ```

4. **Upload a test video:**

   ```bash
   # Upload the included test video
   aws s3 cp test.mp4 s3://$(terraform output -raw input_bucket)/uploads/test.mp4
   ```

5. **Check the output:**

   After a few minutes, your transcoded HLS files will be available in the output bucket:

   ```bash
   aws s3 ls s3://$(terraform output -raw output_bucket)/uploads/test/
   ```

## Test File

A sample `test.mp4` file is included in this example for testing purposes. You can replace it with your own video file.

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| project_name | Project name for resource tagging | string | "my-video-platform" |
| aws_region | AWS region for deployment | string | "us-east-1" |
| bucket_prefix | Prefix for S3 bucket names | string | "video-streaming" |
| cf_price_class | CloudFront price class | string | "PriceClass_100" |

## Outputs

| Name | Description |
|------|-------------|
| input_bucket | S3 bucket name for uploading raw videos |
| output_bucket | S3 bucket name containing processed HLS videos |
| lambda_function | Lambda function name that processes videos |
| upload_instructions | Instructions for uploading and testing |

## Clean Up

To destroy all resources:

```bash
terraform destroy
```

## Notes

- Videos must be uploaded to the `uploads/` prefix in the input bucket to trigger processing
- MediaConvert transcodes videos to HLS format with 5-second segments
- Processing time depends on video size and length

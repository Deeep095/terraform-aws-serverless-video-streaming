# terraform-aws-serverless-video-streaming

[![Terraform Registry](https://img.shields.io/badge/Terraform%20Registry-v1.0.0-blue.svg)](https://registry.terraform.io/modules/Deeep095/serverless-video-streaming/aws)

Terraform module for deploying a **Serverless Video Streaming Architecture** on AWS using S3, Lambda, and MediaConvert.

## Architecture

```
                                 ┌─────────────────────────────────────────────────────────────┐
                                 │                    AWS Cloud                                │
                                 │                                                             │
┌──────────┐                     │  ┌─────────────┐    ┌──────────┐    ┌──────────────┐       │
│  User    │ ─── Upload ────────▶│  │   Input     │───▶│  Lambda  │───▶│ MediaConvert │       │
│  Video   │                     │  │  S3 Bucket  │    │ Function │    │   (HLS)      │       │
└──────────┘                     │  └─────────────┘    └──────────┘    └──────────────┘       │
                                 │        │                                    │              │
                                 │        │          S3 Event                  │              │
                                 │        └──────── Trigger ───────────────────┘              │
                                 │                                             │              │
                                 │                                    ┌────────▼────────┐     │
                                 │                                    │     Output      │     │
                                 │                                    │    S3 Bucket    │     │
                                 │                                    │   (HLS Files)   │     │
                                 │                                    └─────────────────┘     │
                                 └─────────────────────────────────────────────────────────────┘
```

## Features

- 🎬 **Automatic Video Transcoding** - Videos uploaded to S3 are automatically transcoded to HLS format
- ⚡ **Serverless Architecture** - No servers to manage, scales automatically
- 🔒 **Secure by Default** - S3 buckets with public access blocked, IAM least privilege
- 📦 **HLS Output** - Industry-standard HTTP Live Streaming format
- 🏷️ **Configurable** - Customizable project name, region, and CloudFront price class

## Usage

### Basic Usage

```hcl
module "video_streaming" {
  source  = "Deeep095/serverless-video-streaming/aws"
  version = "1.0.0"

  project_name = "my-video-platform"
  aws_region   = "us-east-1"
}
```

### Complete Example

```hcl
module "video_streaming" {
  source  = "Deeep095/serverless-video-streaming/aws"
  version = "1.0.0"

  project_name   = "production-streaming"
  aws_region     = "us-west-2"
  bucket_prefix  = "prod-videos"
  cf_price_class = "PriceClass_200"
}

# Upload a video
# aws s3 cp video.mp4 s3://<input-bucket>/uploads/video.mp4
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0 |
| random | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |
| random | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_name | Project name tag for resources | `string` | `"video-streaming"` | no |
| aws_region | AWS region to deploy resources in | `string` | `"us-east-1"` | no |
| bucket_prefix | The name prefix for S3 buckets | `string` | `"video-bucket"` | no |
| cf_price_class | CloudFront Price Class to use | `string` | `"PriceClass_100"` | no |

## Outputs

| Name | Description |
|------|-------------|
| input_bucket_name | Name of the S3 bucket for uploading videos |
| input_bucket_arn | ARN of the input S3 bucket |
| output_bucket_name | Name of the S3 bucket for processed videos |
| output_bucket_arn | ARN of the output S3 bucket |
| lambda_function_name | Name of the Lambda function that processes videos |
| lambda_function_arn | ARN of the Lambda function |
| mediaconvert_role_arn | ARN of the MediaConvert IAM role |
| upload_path | S3 path prefix for uploading videos |

## How It Works

1. **Upload**: Upload a video file to the input S3 bucket under the `uploads/` prefix
2. **Trigger**: S3 event notification triggers the Lambda function
3. **Process**: Lambda submits a transcoding job to AWS MediaConvert
4. **Transcode**: MediaConvert converts the video to HLS format with 5-second segments
5. **Output**: Transcoded HLS files are stored in the output S3 bucket

## Quick Start

1. Deploy the module:
   ```bash
   terraform init
   terraform apply
   ```

2. Upload a video:
   ```bash
   aws s3 cp your-video.mp4 s3://$(terraform output -raw input_bucket_name)/uploads/your-video.mp4
   ```

3. Wait for processing (check MediaConvert console for job status)

4. Access your HLS files:
   ```bash
   aws s3 ls s3://$(terraform output -raw output_bucket_name)/uploads/your-video/
   ```

## Examples

- [Complete Example](examples/complete) - Full deployment with test video

## Supported Regions

The module supports the following AWS regions:
- us-east-1, us-west-1, us-west-2
- eu-west-1, eu-central-1
- ap-south-1, ap-southeast-1, ap-southeast-2, ap-northeast-1
- sa-east-1, ca-central-1, af-south-1

## License

MIT License - see [LICENSE](LICENSE) for details.

## Author

Created by [Deeep095](https://github.com/Deeep095)

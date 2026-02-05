
# Example of a Serverless Video Streaming Architecture using Terraform

# This example shows how to use the terraform-aws-serverless-video-streaming module to create a complete serverless video streaming infrastructure.

# Architecture:
#   1. Upload video to S3 input bucket (uploads/ prefix)
#   2. S3 triggers Lambda function
#   3. Lambda submits job to AWS MediaConvert
#   4. MediaConvert transcodes video to HLS format
#   5. Output stored in S3 output bucket

module "video_streaming" {
  source = "Deeep095/serverless-video-streaming/aws"
  # For local testing, use:
  # source = "../../"

  project_name   = "my-video-platform"
  aws_region     = "us-east-1"
  bucket_prefix  = "video-streaming"
  cf_price_class = "PriceClass_100"
}


# Outputs
output "input_bucket" {
  description = "S3 bucket for uploading raw videos"
  value       = module.video_streaming.input_bucket_name
}

output "output_bucket" {
  description = "S3 bucket containing processed HLS videos"
  value       = module.video_streaming.output_bucket_name
}

output "lambda_function" {
  description = "Lambda function that processes videos"
  value       = module.video_streaming.lambda_function_name
}

output "upload_instructions" {
  description = "Instructions for uploading videos"
  value       = <<-EOT
    
    To upload a video for processing:
    
    aws s3 cp test.mp4 s3://${module.video_streaming.input_bucket_name}/uploads/test.mp4
    
    The video will be automatically transcoded to HLS format and stored in:
    s3://${module.video_streaming.output_bucket_name}/uploads/test/
    
  EOT
}

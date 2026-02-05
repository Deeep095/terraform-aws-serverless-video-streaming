###############################################################################
# Simple Example - Serverless Video Streaming
###############################################################################
# This is a minimal example showing basic module usage.
###############################################################################

module "video_streaming" {
  source = "Deeep095/serverless-video-streaming/aws"
  # For local testing, use:
  # source = "../../"

  project_name = "simple-video"
  aws_region   = "us-east-1"
}

output "input_bucket" {
  value = module.video_streaming.input_bucket_name
}

output "output_bucket" {
  value = module.video_streaming.output_bucket_name
}

variable "bucket_prefix" {
  description = "The name of the S3 bucket to store files"
  type        = string
  default     = "video-bucket"
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources in"
  default     = "us-east-1"
  validation {
    condition     = contains([
      "us-east-1", "us-west-1", "us-west-2", 
      "eu-west-1", "eu-central-1", "ap-south-1",
      "ap-southeast-1", "ap-southeast-2", "ap-northeast-1",
      "sa-east-1", "ca-central-1", "af-south-1"
    ], var.aws_region)
    error_message = "The aws_region must be a valid AWS region."
  }
}

variable "project_name" {
    description = "Project name tag for resources"
    type        = string
    default = "video-streaming"
    
}

variable "cf_price_class" {
  type = string
  description = "CloudFront Price Class to use"
  default = "PriceClass_100"
}

resource "random_id" "rand" {
  byte_length = 4
}
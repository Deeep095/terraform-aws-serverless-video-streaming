output "input_bucket_name" {
  description = "Name of the S3 bucket for uploading videos"
  value       = aws_s3_bucket.input.bucket
}

output "input_bucket_arn" {
  description = "ARN of the input S3 bucket"
  value       = aws_s3_bucket.input.arn
}

output "output_bucket_name" {
  description = "Name of the S3 bucket for processed videos"
  value       = aws_s3_bucket.output.bucket
}

output "output_bucket_arn" {
  description = "ARN of the output S3 bucket"
  value       = aws_s3_bucket.output.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function that processes videos"
  value       = aws_lambda_function.process_video.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.process_video.arn
}

output "mediaconvert_role_arn" {
  description = "ARN of the MediaConvert IAM role"
  value       = aws_iam_role.mediaconvert_role.arn
}

output "upload_path" {
  description = "S3 path prefix for uploading videos (videos must be uploaded here to trigger processing)"
  value       = "s3://${aws_s3_bucket.input.bucket}/uploads/"
}

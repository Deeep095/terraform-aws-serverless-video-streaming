
resource "aws_s3_bucket" "input" {
  bucket        = "${var.project_name}-input-${random_id.rand.hex}"
  force_destroy = true
  tags = { Name = "${var.project_name}-input" }
}

resource "aws_s3_bucket" "output" {
  bucket        = "${var.project_name}-output-${random_id.rand.hex}"
  force_destroy = true
  tags = { Name = "${var.project_name}-output" }
}

# Enable Versioning
resource "aws_s3_bucket_versioning" "input_versioning" {
  bucket = aws_s3_bucket.input.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_versioning" "output_versioning" {
  bucket = aws_s3_bucket.output.id
  versioning_configuration { status = "Enabled" }
}


# Block Public Access
resource "aws_s3_bucket_public_access_block" "input_block" {
  bucket                  = aws_s3_bucket.input.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "output_block" {
  bucket                  = aws_s3_bucket.output.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
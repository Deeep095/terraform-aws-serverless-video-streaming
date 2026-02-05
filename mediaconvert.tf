
//mediaconvert.tf

#mediaconvert iam role
data "aws_iam_policy_document" "mediaconvert_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["mediaconvert.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "mediaconvert_role" {
  name               = "${var.project_name}-mediaconvert-role"
  assume_role_policy = data.aws_iam_policy_document.mediaconvert_assume.json
}

data "aws_iam_policy_document" "mediaconvert_policy" {
  statement {
    effect = "Allow"
    actions = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
    resources = [
      aws_s3_bucket.input.arn,
      "${aws_s3_bucket.input.arn}/*",
      aws_s3_bucket.output.arn,
      "${aws_s3_bucket.output.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

# --- REMOVE THIS ENTIRE RESOURCE BLOCK ---
/*
resource "aws_iam_role_policy" "lambda_passrole_policy" {
  name = "LambdaAllowPassRole"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement =,
        Resource = aws_iam_role.mediaconvert_role.arn
      },
      {
        Effect   = "Allow",
        Action   = [
          "mediaconvert:CreateJob",
          "mediaconvert:GetJob",
          "mediaconvert:ListJobs"
        ],
        Resource = "*"
      }
    ]
  })
}
*/
# --- END OF REMOVED BLOCK ---


resource "aws_iam_policy" "mediaconvert_policy" {
  name   = "${var.project_name}-mediaconvert-policy"
  policy = data.aws_iam_policy_document.mediaconvert_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_mc_policy" {
  role       = aws_iam_role.mediaconvert_role.name
  policy_arn = aws_iam_policy.mediaconvert_policy.arn
}

resource "aws_lambda_function" "process_video" {
  function_name = "${var.project_name}-process-video"
  role          = aws_iam_role.lambda_exec.arn
  runtime       = "python3.10"
  handler       = "lambda_function.lambda_handler"
  filename         = data.archive_file.lambda_function_zip.output_path
  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256

  environment {
    variables = {
      INPUT_BUCKET      = aws_s3_bucket.input.bucket
      OUTPUT_BUCKET     = aws_s3_bucket.output.bucket
      MEDIACONVERT_ROLE = aws_iam_role.mediaconvert_role.arn
    }
  }


  timeout     = 90
  memory_size = 512
}


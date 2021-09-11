locals {
  archive               = "${local.lambda_dir}/lambda_example.zip"
  bucket_name           = "some-fancy-s3-bucket-name-here" // NOTE: S3 bucket names need to be unique
  lambda_dir            = "${path.module}/lambda"
  lambda_name           = "lambda_example"
  log_retention_in_days = 30
  region                = "us-east-1"
  md5_file              = "${local.lambda_dir}/lastbuild.md5"
  sha256_file           = "${local.lambda_dir}/lastbuild.sha256"
  tags = {
    testing = "true"
    project = "lambda example"
  }
}

provider "aws" {
  region = local.region
}

resource "aws_s3_bucket" "lambda_example" {
  bucket = local.bucket_name
  tags   = local.tags
}

resource "aws_s3_bucket_object" "lambda_example" {
  bucket = aws_s3_bucket.lambda_example.bucket
  key    = local.lambda_name
  source = local.archive
  etag   = file(local.md5_file)
  tags   = local.tags
}

resource "aws_iam_role" "lambda_example" {
  name = local.lambda_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda_example" {
  function_name    = local.lambda_name
  handler          = local.lambda_name
  role             = aws_iam_role.lambda_example.arn
  runtime          = "go1.x"
  s3_bucket        = aws_s3_bucket.lambda_example.bucket
  s3_key           = aws_s3_bucket_object.lambda_example.id
  source_code_hash = filebase64(local.sha256_file)
  tags             = local.tags

  environment {
    variables = {
      EXAMPLE = "true"
    }
  }

  depends_on = [aws_cloudwatch_log_group.lambda_example]
}

resource "aws_cloudwatch_log_group" "lambda_example" {
  name              = "/aws/lambda/${local.lambda_name}"
  retention_in_days = local.log_retention_in_days
  tags              = local.tags
}

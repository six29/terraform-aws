# backend.tf - S3 bucket and DynamoDB table for state management
provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

# Create S3 bucket for state storage
resource "aws_s3_bucket" "terraform_state" {
  bucket = "paul-terraform-aws-state-bucket"  # must be unique globally
  
  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = false
  }
}

# Enable versioning for state files
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
# Output the bucket name and DynamoDB table name
output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}
output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}
#State Bucket
resource "aws_s3_bucket" "tfstate" {

  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Purpose     = "Terraform State"
  }
}

#Versioning
resource "aws_s3_bucket_versioning" "versioning" {

  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

#Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {

  bucket = aws_s3_bucket.tfstate.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"
    }
  }
}

#Public Access Block
resource "aws_s3_bucket_public_access_block" "public_access" {

  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true

  block_public_policy     = true

  ignore_public_acls      = true

  restrict_public_buckets = true
}

#Lifecycle Policy
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {

  bucket = aws_s3_bucket.tfstate.id

  rule {

    id = "state-versions"

    status = "Enabled"

    noncurrent_version_expiration {

      noncurrent_days = 90
    }
  }
}

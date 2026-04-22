data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  bucket_name = "shopsite-${var.env}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.id}"
}


resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
  
  tags = {
    Name        = "Shopsite-${var.env}-bucket"
    Environment = var.env
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
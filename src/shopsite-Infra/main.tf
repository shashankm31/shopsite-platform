data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  bucket_name = "shopsite-${var.env}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.id}"
}


resource "aws_s3_bucket" "shop_site_bucket" {
  bucket = local.bucket_name
  
  tags = {
    Name        = "Shop Site ${var.env} Bucket"
    Environment = var.env
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.shop_site_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.shop_site_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.shop_site_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


  ######### CLOUD FRONT CONFIGURATION #########

#OAC for cloudfront
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "shopsite-oac"
  description                       = "OAC for ShopSite S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#cloudfront distribution
resource "aws_cloudfront_distribution" "cdn" {
  enabled = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.shop_site_bucket.bucket_regional_domain_name
    origin_id   = "shopsiteS3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }
  
  default_cache_behavior {
    target_origin_id = "shopsiteS3Origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]

   cache_policy_id = aws_cloudfront_cache_policy.custom_cache.id 
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}



#custom cache policy
resource "aws_cloudfront_cache_policy" "custom_cache" {
  name = "shopsite-cache-policy"

  parameters_in_cache_key_and_forwarded_to_origin {
    query_strings_config {
      query_string_behavior = "none"
    }
  
  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = "none"
  }
}
  default_ttl = 3600
  min_ttl = 0
  max_ttl = 86400
}

#Attach Secure Bucket Policy to S3 bucket to allow access only from cloudfront OAC for private bucket
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.shop_site_bucket.id


  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.shop_site_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
          }
        }
      }

    ]
  })
}


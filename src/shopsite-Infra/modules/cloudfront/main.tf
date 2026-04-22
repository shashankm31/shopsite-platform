 ######### CLOUD FRONT CONFIGURATION #########

#OAC for cloudfront

#Adding suffix to the OAC name to avoid conflicts with exisiting OACs in the AWS account. This is necessary because OAC names must be unique within an AWS account.

resource "random_id" "suffix" {
  byte_length = 2
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "shopsite-oac-${random_id.suffix.hex}"
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
    domain_name = var.bucket_domain_name 
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
  name = "shopsite-cache-policy-${random_id.suffix.hex}"

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
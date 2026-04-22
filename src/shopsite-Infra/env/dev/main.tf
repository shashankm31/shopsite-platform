provider "aws" {
    region = "ap-south-1"
}

module "s3" {
    source = "../../modules/s3"
    env = "dev"
}

module "cloudfront" {
    source = "../../modules/cloudfront"
    
    bucket_domain_name = module.s3.bucket_domain_name
    bucket_arn = module.s3.bucket_arn
}


resource "aws_s3_bucket_policy" "allow_cloudfront" {
    bucket = module.s3.bucket_id


    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Principal = {
                    Service = "cloudfront.amazonaws.com"
                },
                Action = "s3:GetObject",
                Resource = "${module.s3.bucket_arn}/*",
                Condition = {
                    StringEquals = {
                        "AWS:SourceArn" = module.cloudfront.cloudfront_arn
                    }
                }
            }
        ]
    })
}
#cloudfront outputs

output "cloudfront_domain" {
    value = module.cloudfront.cloudfront_domain
}

output "cloudfront_arn" {
    value = module.cloudfront.cloudfront_arn
}

output "cloudfront_distribution_id" {
    value = module.cloudfront.cloudfront_distribution_id
}


#S3 outputs

output "bucket_name" {
    value = module.s3.bucket_name
}

output "bucket_arn" {
    value = module.s3.bucket_arn
}
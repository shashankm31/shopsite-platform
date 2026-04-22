output "cloudfront_domain"{
    value = aws_cloudfront_distribution.cdn.domain_name 
}

output "cloudfront_arn" {
    value = aws_cloudfront_distribution.cdn.arn
}

output "cloudfront_distribution_id" {
    value = aws_cloudfront_distribution.cdn.id 
}
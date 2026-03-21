output "bucket_name" {
    value = aws_s3_bucket.shop_site_bucket.bucket
}

output "github_access_key_id" {
    value = aws_iam_access_key.github_key.id
    sensitive = true
}

output "github_secret_access_key" {
    value = aws_iam_access_key.github_key.secret
    sensitive = true
}
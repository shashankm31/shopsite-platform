output "github_access_key_id" {
    value = aws_iam_access_key.github_key.id
    sensitive = true
}

output "github_secret_access_key" {
    value = aws_iam_access_key.github_key.secret
    sensitive = true
}
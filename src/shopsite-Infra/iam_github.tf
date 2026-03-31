#IAM User
resource "aws_iam_user" "github_actions" {
    name = "github-actions-deployer"
}

#Create Policy
resource "aws_iam_policy" "github_deploy_policy" {
    name = "github-deploy-policy"

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "s3:PutObject",
                    "s3:DeleteObject",
                    "s3:ListBucket"
                ],
                Resource = [
                    aws_s3_bucket.shop_site_bucket.arn,
                    "${aws_s3_bucket.shop_site_bucket.arn}/*"
                    
                ]
            },
            {
                Effect = "Allow"
                Action = [
                    "cloudfront:CreateInvalidation"
                ],
                Resource = "*"
            }
        ]
    })
    }

    #Attach Policy to User
    resource "aws_iam_user_policy_attachment" "attach_policy" {
        user = aws_iam_user.github_actions.name
        policy_arn = aws_iam_policy.github_deploy_policy.arn
    }

    #Create Access key for Github Actions (secrets keys)
    resource "aws_iam_access_key" "github_key" {
        user = aws_iam_user.github_actions.name
    }


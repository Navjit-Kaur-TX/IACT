// This script is basically for create of IAM Role for lambda service
//IAM ROLE
resource "aws_iam_role" "lambda_role"{
    name = "terraform_aws_lambda_role"
    assume_role_policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "lambda.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid": ""
            }
        ]
    }
    )
}

//IAM POLICY
resource "aws_iam_policy" "iam_policy_for_lambda" {
    name = "aws_iam_policy_for_terraform_aws_lambda_role"
    path = "/"
    description = "AWS IAM policy for managing aws lambda role"
    policy = jsonencode(
    {
        "Version": "2012-10-17"
        "Statement": [
            {
                "Action": [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Resource": "arn:aws:logs:*:*:*",
                "Effect": "Allow"
            }
        ]
    }
    )
}

//POLICY ROLE ATTACHMENT
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
    role = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

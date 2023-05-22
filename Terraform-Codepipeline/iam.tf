resource "aws_iam_role" "demoiactcodepipeline" {
  name = "demoiactcodepipeline"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "demoiact" {
  statement{
        sid = ""
        actions = ["codestar-connections:UseConnection"]
        resources = ["*"]
        effect = "Allow"
  }  
  statement {
    sid = ""
    actions = ["cloudwatch:*", "s3:*", "codebuild:*"]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "demoiactpolicy" {
  name = "demoiactpolicy"
  path = "/"
  description = "Pipeline policy"
  policy = data.aws_iam_policy_document.demoiact.json
}

resource "aws_iam_role_policy_attachment" "demoiactattach" {
  policy_arn = aws_iam_policy.demoiactpolicy.arn
  role = aws_iam_role.demoiactcodepipeline.id
}

resource "aws_iam_role" "demoiactcodebuild" {
  name = "demoiactcodebuild"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "tf-cicd-build-policies" {
    statement{
        sid = ""
        actions = ["codestar-connections:UseConnection"]
        resources = ["*"]
        effect = "Allow"
    }
    statement{
        sid = ""
        actions = ["logs:*", "s3:*", "codebuild:*", "secretsmanager:*","iam:*"]
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "tf-cicd-build-policy" {
    name = "tf-cicd-build-policy"
    path = "/"
    description = "Codebuild policy"
    policy = data.aws_iam_policy_document.tf-cicd-build-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment1" {
    policy_arn  = aws_iam_policy.tf-cicd-build-policy.arn
    role        = aws_iam_role.demoiactcodebuild.id
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment2" {
    policy_arn  = "arn:aws:iam::aws:policy/PowerUserAccess"
    role        = aws_iam_role.demoiactcodebuild.id
}
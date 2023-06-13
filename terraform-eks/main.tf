# Configure the AWS provider
provider "aws" {
  region = "us-west-2"  # Replace with your desired region
}

# Create the EKS cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.my_cluster_role.arn
  version  = "1.21"  # Replace with your desired EKS version

  vpc_config {
    subnet_ids = ["subnet-12345678", "subnet-23456789"]  # Replace with your desired subnet IDs
  }

  depends_on = [aws_iam_role_policy_attachment.my_cluster_attachment]
}

# Define the IAM role for the EKS cluster
resource "aws_iam_role" "my_cluster_role" {
  name = "my-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach the necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "my_cluster_attachment" {
  role       = aws_iam_role.my_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


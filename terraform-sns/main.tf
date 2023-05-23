provider "aws" {
  region = "us-east-1"
}

#SNS topic creation
resource "aws_sns_topic" "user_updates" {
  name = "my-topic-1"
}

#SNS Subcription for Application to Person (EMAIL) protocol
resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol  = "email"
  endpoint  = var.emailid
}

#SNS Subcription for Application to Application (SQS) protocol

# resource "aws_sns_topic_subscription" "example" {
#   topic_arn = aws_sns_topic.user_updates.arn
#   protocol  = "sqs"
#   endpoint  = var.sqs_arn
# }
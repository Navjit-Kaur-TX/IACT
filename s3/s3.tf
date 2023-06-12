resource "aws_s3_bucket" "Tf-bucket" {
  bucket = "first-bucket04" // Bucket name must be globally unique and must not contain spaces or uppercase letters. Name of the bucket. If omitted,Terraform will assign a random, unique name.
  acl    = "private" // Each ACL has a predefined set of grantees and permissions.

 
  versioning {
     enabled =  true // You can use S3 Versioning to keep multiple versions of an object in one bucket
   }

  tags = {
    Name = "My Iac-Bucket",
    Service = "devops"
    Environment = "Dev"
  }
}

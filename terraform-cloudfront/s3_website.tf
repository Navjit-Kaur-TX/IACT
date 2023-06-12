# create S3 Bucket:
resource "aws_s3_bucket" "bucket" {
  bucket_prefix = var.bucket_prefix
  tags = {
    "Project"   = "cfornt"
    "ManagedBy" = "Terraform"
  }
  force_destroy = true
}

#Provides a resource to manage S3 Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#Manages S3 bucket-level Public Access Block configuration
resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = true
}

#Provides an S3 bucket ACL resource.
resource "aws_s3_bucket_acl" "bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.public_block,
  ]
  bucket = aws_s3_bucket.bucket.id
  acl = "public-read"
}

#Attaches a policy to an S3 bucket resource.
resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject", "s3:PutObject"]
        Resource = [aws_s3_bucket.bucket.arn,
          "${aws_s3_bucket.bucket.arn}/*",
        ]
      },
    ]
  })
}

# create S3 website hosting:
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

# add bucket policy to let the CloudFront OAI get objects:
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_policy_document.json
}

#upload website files to s3:
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  for_each     = fileset("uploads/", "*")
  key          = "website/${each.value}"
  source       = "uploads/${each.value}"
  etag         = filemd5("uploads/${each.value}")
  content_type = "text/html"
  depends_on = [
    aws_s3_bucket.bucket
  ]
}
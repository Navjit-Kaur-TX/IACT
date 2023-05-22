resource "aws_s3_bucket" "demoiact4" {
  bucket = "demoiact4"
}

resource "aws_s3_bucket_versioning" "demoversioning" {
  bucket = aws_s3_bucket.demoiact4.id
  versioning_configuration {
    status = "Enabled"
  }
}
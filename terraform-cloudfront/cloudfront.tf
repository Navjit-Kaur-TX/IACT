#creating OAI :
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.domain_name}"
}

#creating CF distribution :
resource "aws_cloudfront_distribution" "cf_dist" {
  enabled             = true #Whether the distribution is enabled to accept end user requests for content.
  default_root_object = "website/index.html" #Object that you want CloudFront to return when an end user requests the root URL.
  #One or more origins for this distribution
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name #DNS domain name of either the S3 bucket, or web site of your custom origin.
    origin_id   = aws_s3_bucket.bucket.id #Unique identifier for the origin.
    #The CloudFront S3 origin configuration information
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path #The CloudFront origin access identity to associate with the origin.
    }
  }
  # Default cache behavior for this distribution
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"] #Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin.
    cached_methods         = ["GET", "HEAD", "OPTIONS"] #Controls whether CloudFront caches the response to requests using the specified HTTP methods.
    target_origin_id       = aws_s3_bucket.bucket.id #Value of ID for the origin that you want CloudFront to route requests to when a request matches the path pattern either for a cache behavior or for the default cache behavior.
    viewer_protocol_policy = "redirect-to-https" #Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern.
    # specifies how CloudFront handles query strings, cookies and headers
    forwarded_values {
      headers      = []
      query_string = true #Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior.
      cookies {
        forward = "all"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist" #Method that you want to use to restrict distribution of your content by country
      locations        = ["IN", "US", "CA"]
    }
  }
  tags = {
    "Project"   = "cfront"
    "ManagedBy" = "Terraform"
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
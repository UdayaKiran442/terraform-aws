provider "aws" {
  region = "ap-south-1"
}


resource "aws_s3_bucket" "mys3" {
  bucket = "terraform-cloud-front-demo-gonuguntla"
}

resource "aws_s3_bucket_ownership_controls" "s3oc" {
  bucket = aws_s3_bucket.mys3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

data "aws_canonical_user_id" "current" {
  
}

resource "aws_s3_bucket_acl" "name" {
  depends_on = [ aws_s3_bucket_ownership_controls.s3oc ]
  bucket = aws_s3_bucket.mys3.id
   access_control_policy {
    grant {
      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
      permission = "READ"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "READ_ACP"
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "This is OAI"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid = "1"
    actions = [ "s3:GetObject" ]
    resources = ["${aws_s3_bucket.mys3.arn}/*"]

    principals {
      type = "AWS"
      identifiers = [ aws_cloudfront_origin_access_identity.oai.iam_arn ]
    }
  }
}


resource "aws_s3_bucket_policy" "s3policy" {
  bucket = aws_s3_bucket.mys3.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.mys3.bucket_regional_domain_name
    origin_id                = "myS3Origin"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  }

  aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    cache_policy_id  = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    # forwarded_values {
    #   query_string = false

    #   cookies {
    #     forward = "none"
    #   }
    # }

    viewer_protocol_policy = "allow-all"
    # min_ttl                = 0
    # default_ttl            = 3600
    # max_ttl                = 86400
  }

  # Cache behavior with precedence 0
#   ordered_cache_behavior {
#     path_pattern     = "/content/immutable/*"
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD", "OPTIONS"]
#     target_origin_id = local.s3_origin_id

    # forwarded_values {
    #   query_string = false
    #   headers      = ["Origin"]

    #   cookies {
    #     forward = "none"
    #   }
    # }

#     min_ttl                = 0
#     default_ttl            = 86400
#     max_ttl                = 31536000
#     compress               = true
#     viewer_protocol_policy = "redirect-to-https"
#   }

  # Cache behavior with precedence 1
#   ordered_cache_behavior {
#     path_pattern     = "/content/*"
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = local.s3_origin_id

    # forwarded_values {
    #   query_string = false

    #   cookies {
    #     forward = "none"
    #   }
    # }

    # min_ttl                = 0
    # default_ttl            = 3600
    # max_ttl                = 86400
    # compress               = true
    # viewer_protocol_policy = "redirect-to-https"
#   }

#   price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  

}
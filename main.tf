
provider "aws" {

  region = var.region

}



# Create S3 Bucket

resource "aws_s3_bucket" "static_site" {

  bucket = var.bucket_name



  tags = {

    Name = "static-site-bucket"

  }

}



# Enable website hosting

resource "aws_s3_bucket_website_configuration" "website" {

  bucket = aws_s3_bucket.static_site.bucket



  index_document {

    suffix = "index.html"

  }

}



# Public bucket policy

resource "aws_s3_bucket_policy" "public_policy" {

  bucket = aws_s3_bucket.static_site.id



  policy = jsonencode({

    Version = "2008-10-17"

    Statement = [

      {

        Sid       = "PublicReadGetObject"

        Effect    = "Allow"

        Principal = "*"

        Action    = "s3:GetObject"

        Resource  = "${aws_s3_bucket.static_site.arn}/*"

      }

    ]

  })

}



# Upload index.html file

resource "aws_s3_object" "index" {

  bucket       = aws_s3_bucket.static_site.bucket

  key          = "index.html"

  source       = "index.html"

  content_type = "text/html"

}

provider "aws" {
  profile = "default"
  region = "us-east-2"
}

resource "aws_s3_bucket" "my_first_bucket" {
  bucket = "tf-course-aws-bucket-050922"
  acl    = "private"
}
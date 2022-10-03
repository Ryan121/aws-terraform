# provider "aws" {
#   region     = "us-west-2"
#   access_key = "AKIARSOMS6S23UFUTMMY"
#   secret_key = "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"
# }

# resource "aws_s3_bucket" "prod_my_first_bucket" {
#   bucket = "tf-course-aws-bucket-05092022"
#   acl    = "private"
# }


# resource "aws_default_vpc" "default" {
#   tags = {
#     Name = "Default VPC"
#   }
# }

# resource "aws_security_group" "prod_web" {
#   name        = "prod_web"
#   description = "Allow standard http and https ports inbound and all outbound"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     "Terraform" : "true"
#   }

# }

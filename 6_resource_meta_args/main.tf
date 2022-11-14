terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.33.0"
    }
  }
}

provider "aws" {
  # profile    = "default"
  region     = "us-east-1"
  # access_key = ""
  # secret_key = ""
}

locals {
  ami = "ami-09d3b3274b6c5d4aa"
}

locals {
project_name = "Ryan"
}

resource "aws_instance" "app_server" {

for_each = {
    nano  = "t2.nano"
    micro = "t2.micro"
    small = "t2.small"
}
  # count = 2
  # ami           = local.ami
  ami = local.ami
  # instance_type = var.instance_type
  instance_type = each.value

#   tags = {
#     Name = "MyTerraformEC2Instance - ${local.project_name} - ${count.index}"
#   }

  tags = {
    Name = "MyTerraformEC2Instance - ${local.project_name} - ${each.key}"
  }

  depends_on = [
    aws_s3_bucket.create_s3_bucket
  ]
}

output "instance_ip_addr" {
  # value = aws_instance.app_server[*].public_ip
  value = values(aws_instance.app_server)[*].public_ip
}

variable "instance_type"{
  # type = string
  default = "t2.micro"
}

resource "aws_s3_bucket" "create_s3_bucket"{
    bucket = "my-bucket-67890495876"

    tags = {
        Name = "My Bucket"
        Environment = "Dev"
    }
}

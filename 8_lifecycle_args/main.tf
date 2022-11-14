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

  ami = local.ami
  instance_type = var.instance_type

  tags = {
    Name = "MyTerraformEC2Instance - ${local.project_name}"
  }

  lifecycle {
    prevent_destroy = true
  }
}

output "instance_ip_addr" {
  value = aws_instance.app_server.public_ip
}

variable "instance_type"{
  # type = string
  default = "t2.micro"
}

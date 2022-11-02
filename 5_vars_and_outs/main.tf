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
  region     = "us-west-2"
  # access_key = ""
  # secret_key = ""
}

locals {
  project_name = "Ryan"
}


resource "aws_instance" "app_server" {
  ami           = "ami-017fecd1353bcc96e"
  instance_type = var.instance_type

  tags = {
    Name = "MyTerraformEC2Instance - ${local.project_name}"
  }
}

output "instance_ip_addr" {
  value = aws_instance.app_server.public_ip
}

variable "instance_type"{
  type = string
}

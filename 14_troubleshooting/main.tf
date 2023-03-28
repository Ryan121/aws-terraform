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
  region = "us-east-1"
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

  ami           = local.ami
  instance_type = var.instance_type

  #   tags = {
  #     Name = "MyTerraformEC2Instance - ${local.project_name} - ${count.index}"
  #   }

  tags = {
    Name = "MyTerraformEC2Instance - ${local.project_name}"
  }

}

output "instance_ip_addr" {
  value = aws_instance.app_server.public_ip
  # value = values(aws_instance.app_server)[*].public_ip
}

variable "instance_type" {
  # type = string
  default = "t2.micro"
}


# Debug Logs
# TF_LOGS=TRACE terraform apply
# terraform apply TF_LOG=TRACE TF_LOG_PATH=./terraform.log
# TF_LOG=TRACE TF_LOG_PATH=./terraform.log terraform apply
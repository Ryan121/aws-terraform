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



data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



locals {
  project_name = "Ryan"
}

locals {
  ami = "ami-09d3b3274b6c5d4aa"
}


resource "aws_instance" "app_server" {
  # ami           = local.ami
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = "MyTerraformEC2Instance - ${local.project_name}"
  }
}

output "instance_ip_addr" {
  value = aws_instance.app_server.public_ip

}

variable "instance_type"{
  # type = string
  default = "t2.micro"
}

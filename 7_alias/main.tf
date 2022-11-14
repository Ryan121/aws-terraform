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
  alias="east"
}

provider "aws" {
  # profile    = "default"
  region     = "us-west-1"
  # access_key = ""
  # secret_key = ""
  alias="west"
}

variable "instance_type_east" {
  default = "ami-09d3b3274b6c5d4aa"
}
variable "instance_type_west" {
  default = "ami-017c001a88dd93847"
}

locals {
project_name = "Ryan"
}

resource "aws_instance" "app_east_server" {

  ami = var.instance_type_east
  instance_type = var.instance_type
  provider = aws.east

  tags = {
    Name = "MyTerraformEC2Instance - ${local.project_name} - east"
  }
}

resource "aws_instance" "app_west_server" {

  ami = var.instance_type_west
  instance_type = var.instance_type
  provider = aws.west

  tags = {
    Name = "MyTerraformEC2Instance - ${local.project_name} - west"
  }
}

output "east_instance_ip_addr" {
  value = aws_instance.app_east_server.public_ip
}

output "west_instance_ip_addr" {
  value = aws_instance.app_west_server.public_ip
}

variable "instance_type"{
  # type = string
  default = "t2.micro"
}

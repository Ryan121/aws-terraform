terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "RS-terraform"

  workspaces {
      name = "provisioners"
    }
  }

    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.33.0"
    }
  }
}

  provider "aws" {

  region     = "us-east-1"

}

data "aws_vpc" "main" {
    id = "vpc-0427daa8a87a9817c"
}
# Oregon vpc-0892e9b812360192f
resource "aws_security_group" "rs_server_SG" {
  name        = "rs_server_SG"
  description = "Security Group for RS"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
  {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups = []
    self = false
  },

  {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups = []
    self = false
  }
 ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups = []
    self = false
  }

}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbTj9msrDONFcDPs6QgT0xpUgNQTPCIX+7mP7a6GBvZP0ELb79+DFcpArJDD0tfnwoNZWFzbdlcZfMCva28sAT0ZDE/OB2NS4T+Um5tU8hKYrd3Im+eYwen6eUb3gdxiF7Wl6kqWJl0If9hU1VfaxvgB08gbcrAn9a39E8DeBnx8NcUrcR+1x+bjYSfxRnk2PoTqtB936Pgn/zRuXdNRrL5X5RUlSY5aMRuVT2YXbB3zRdui/LwFGB26N6llUVekK4PhkDW3Y3HrFUJ2rZqXKlmaF5ORDf5EC+Vh7pMUcI9bOnzowmtJQWAfEmuqCJpkY2jiTbyP7n9Q90E2+j6hWr ead\rsers@GB5CD9502WZ8"
}

data "template_file" "user_data" {
    template = file("./userdata.yml")
}

resource "aws_instance" "app_server" {
  ami           = "ami-026b57f3c383c2eec"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = [aws_security_group.rs_server_SG.id]
  user_data = data.template_file.user_data.rendered

  tags = {
    Name = "MyTerraformEC2Instance"
  }
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}


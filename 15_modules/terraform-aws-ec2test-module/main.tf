

provider "aws" {

  region     = "us-east-1"

}

data "aws_vpc" "main" {
    id = var.vpc_id
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
    cidr_blocks      = [var.my_ip_with_cidr]
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
  public_key = var.public_key
}

data "template_file" "user_data" {
    # template = file("./userdata.yml")
    template = file("${abspath(path.module)}/userdata.yml")
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "${data.aws_ami.amazon-linux-2.id}"
  instance_type = var.instance_type
  key_name      = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = [aws_security_group.rs_server_SG.id]
  user_data = data.template_file.user_data.rendered

  tags = {
    Name = var.server_name
  }
}



terraform {

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
    cidr_blocks      = ["165.225.198.246/32"]
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdrM2KFDakq4hzsXtOVuYPsmvaA4AvKrKSV+i//O6ND7bulPjzxVPEvRmBOFljGJfujxRaGgcIEoss6VLlUZTD7c6iPy0Q6UzBSVPHBSU1KVyDH7vhYc+CFEZz/pXOqLZbQ83fSCJNqo94VVtAxipco8wlDoHKr5Sbh+/JM8oGF7svisfxqAl3kZoec2erUOOF8OmSlN6tSPhA6eRgYmYx2Ig6NqimWoMiDuSK5VZPkanZD4sZE3sSlumLkFU/zGa9m1aci7jhzafsvltHrcNIP0uIQwHI06OddbMzH4istLD5t40waYBCd8/cRI84E7MP0lxR4JwiT5KLsvpiQsAX ead\rsers@GB5CD9502WZ8"
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

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
  # provisioner "remote-exec" {
  #   inline = [
  #     "echo ${self.private_ip} >> /home/ec2-user/private_ips.txt"
  #   ]
  #   connection {
  #     type        = "ssh"
  #     user        = "ec2-user"
  #     host        = "${self.public_ip}"
  #     private_key = "${file("C:/Users/rsers/Desktop/creds/terraform")}"
  #   }
  # }


  tags = {
    Name = "MyTerraformEC2Instance"
  }
}

resource "null_resource" "status" {
    provisioner "local-exec" {
        command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.app_server.id}"
    }
    depends_on = [
        aws_instance.app_server
    ]
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}


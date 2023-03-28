terraform {

}

provider "aws" {
  region = "us-east-1"
}

module "apache" {
	source = ".//terraform-aws-ec2test-module"
	vpc_id = "vpc-0427daa8a87a9817c"
	my_ip_with_cidr = "0.0.0.0/32"
	public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdrM2KFDakq4hzsXtOVuYPsmvaA4AvKrKSV+i//O6ND7bulPjzxVPEvRmBOFljGJfujxRaGgcIEoss6VLlUZTD7c6iPy0Q6UzBSVPHBSU1KVyDH7vhYc+CFEZz/pXOqLZbQ83fSCJNqo94VVtAxipco8wlDoHKr5Sbh+/JM8oGF7svisfxqAl3kZoec2erUOOF8OmSlN6tSPhA6eRgYmYx2Ig6NqimWoMiDuSK5VZPkanZD4sZE3sSlumLkFU/zGa9m1aci7jhzafsvltHrcNIP0uIQwHI06OddbMzH4istLD5t40waYBCd8/cRI84E7MP0lxR4JwiT5KLsvpiQsAX ead\rsers@GB5CD9502WZ8"
	instance_type = "t2.micro"
 	server_name = "Apache Example Server"
}

# output "public_ip" {
#   value = module.apache.aws_instance.app_server.public_ip
# }
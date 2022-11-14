terraform {

}

module "aws_server" {
  source=".//aws_server"
  instance_type = "t2.micro"
}
output "instance_ip_addr" {
  value = module.aws_server.instance_ip_addr

}

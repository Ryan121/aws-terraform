terraform {

}

variable "vpc_id" {
  type = string
}

variable "my_ip_with_cidr" {
  type = string
  description = "value"
}

variable "public_key" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "server_name" {
  type = string
}

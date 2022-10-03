terraform {

  backend "remote" {
    hostname = "app.terraform.io"
    organization = "RS-terraform"

  workspaces {
      name = "getting-started"
    }
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.33.0"
    }
  }
}


locals {
  project_name = "Ryan"
}

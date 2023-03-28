terraform {
  backend "s3" {
    bucket = "mybucket-65435321"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
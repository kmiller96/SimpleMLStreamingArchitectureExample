provider "aws" {
  region                  = "ap-southeast-2"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}


terraform {
  backend "s3" {
    bucket = "kale-miller-terraform-states"
    key    = "real-time-wine/terraform.tfstate"

    region                  = "ap-southeast-2"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "default"
  }
}
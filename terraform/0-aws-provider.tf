provider "aws" {
  region = var.region
}

terraform {

  required_version = "~> 1.0"

  backend "s3" {
    bucket         = "bilal-terraform-state-bucket"
    key            = "terraform/state"
    region         = "us-west-2"
    dynamodb_table = "bilal-terraform-lock-table"
    encrypt        = true
  }
}
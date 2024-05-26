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

#   required_providers {
#     helm = {
#       source  = "hasicorp/helm"
#     }
#   }

}
# add role
# OIDC access
#aws sts assume-role --role-arn "arn:aws:iam::637423421416:role/yap-pk-stage-eks-admin-role" --role-session-name test1
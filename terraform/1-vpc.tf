module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs                 = ["${var.region}a", "${var.region}b", "${var.region}c"]

  private_subnets     = var.private_subnets #k8s worker in private subnets
  public_subnets      = var.public_subnets

  enable_nat_gateway      = true # because private subnets are used
  single_nat_gateway      = true
  one_nat_gateway_per_az  = false

  tags = merge(var.tags, { Name = "${var.environment}-vpc" })
}
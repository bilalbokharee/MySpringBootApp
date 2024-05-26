module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs                 = ["${var.region}a", "${var.region}b", "${var.region}c"]

  private_subnets     = var.private_subnets #k8s worker in private subnets
  public_subnets      = var.public_subnets

  private_subnet_tags = var.private_subnet_tags #worker nodes, subnet to be created in, tags help on pod launch for subnet discoverey
  public_subnet_tags  = var.public_subnet_tags

  enable_nat_gateway      = true # because private subnets are used
  single_nat_gateway      = true
  one_nat_gateway_per_az  = false

  tags = merge(var.tags, { Name = "${var.environment}-vpc" })
}
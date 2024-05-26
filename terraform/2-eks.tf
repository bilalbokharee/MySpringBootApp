module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.11.1"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {

    general = {
      desired_size = var.node_group_desired_capacity
      max_size     = var.node_group_max_capacity
      min_size     = var.node_group_min_capacity

      instance_type = var.node_instance_type
      capacity_type = "ON_DEMAND"

      labels = {
        role = "general"
      }
    }
  }

  tags = merge(var.tags, { Name = var.cluster_name })
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.2.1"

  repository_name = "my-devops-assessment-repo"

  repository_image_scan_on_push = "true"

  repository_image_tag_mutability = "MUTABLE"

  tags = merge(var.tags, { Name = var.cluster_name })
}

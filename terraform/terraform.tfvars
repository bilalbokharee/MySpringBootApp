region              = "us-west-2"
cluster_name        = "my-devops-assessment"
cluster_version     = "1.28"
environment         = "dev"
public_subnet_tags  = {
  "kubernetes.io/role/elb"            = "1",
  "kubernetes.io/cluster/my-devops-assessment" = "owned"
}
private_subnet_tags = {
  "kubernetes.io/cluster/my-devops-assessment" = "owned"
}
tags = {
  Project     = "MyProject"
  Environment = "dev"
}

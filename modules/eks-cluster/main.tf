resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = "1.29"

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = var.security_group_ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  tags = {
    Name = var.cluster_name
  }
}

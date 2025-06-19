resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.env}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  ami_type       = "AL2_x86_64"
  instance_types = [var.instance_type]

  remote_access {
    ec2_ssh_key = var.key_name
  }

  tags = {
    Name = "${var.env}-node-group"
  }
}

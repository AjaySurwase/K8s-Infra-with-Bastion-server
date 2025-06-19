resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.env}-eks-cluster-sg"
  description = "Security group for EKS cluster to allow API access from jumpbox"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Or replace with var.allowed_ip if jumpbox IP only
    description = "Allow EKS API access from VPC/jumpbox"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-eks-cluster-sg"
  }
}

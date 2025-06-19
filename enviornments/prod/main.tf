provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source                = "../../modules/vpc"
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_cidr   = var.private_subnet_cidr
  private_subnet_cidr_2 = var.private_subnet_cidr_2
  az1                   = var.az1
  az2                   = var.az2
  env                   = var.env
}

module "bastion" {
  source           = "../../modules/bastion"
  env              = var.env
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  allowed_ip       = var.allowed_ip
  ami_id           = var.ami_id
  key_name         = var.key_name
}

output "bastion_public_ip" {
  value = module.bastion.bastion_eip
}

module "eks_cluster" {
  source           = "../../modules/eks-cluster"
  cluster_name     = "${var.env}-cluster"
  cluster_role_arn = aws_iam_role.eks_cluster_role.arn
  private_subnet_ids = [
    module.vpc.private_subnet_id,
    module.vpc.private_subnet_id_2
  ]
  security_group_ids = [aws_security_group.eks_cluster_sg.id]
}


module "eks_nodegroup" {
  source        = "../../modules/eks-node-group"
  cluster_name  = module.eks_cluster.cluster_name
  node_role_arn = aws_iam_role.eks_node_role.arn
  private_subnet_ids = [
    module.vpc.private_subnet_id,
    module.vpc.private_subnet_id_2
  ]

  desired_capacity = 2
  min_capacity     = 1
  max_capacity     = 3

  instance_type = "t3.medium"
  key_name      = var.key_name
  env           = var.env
}



# Fetch EKS Cluster Info (output from module)
data "aws_eks_cluster" "this" {
  name = module.eks_cluster.cluster_name
}

# Allow access to EKS control plane from within VPC (adjust CIDR as needed)
resource "aws_security_group_rule" "allow_eks_api_from_jumpbox" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"] # Your VPC CIDR, or restrict to jumpbox SG if needed
  security_group_id = data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  description       = "Allow EKS API access from VPC/jumpbox"
}

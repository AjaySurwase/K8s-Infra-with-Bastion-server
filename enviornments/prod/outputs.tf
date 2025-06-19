output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}
output "bastion_ip" {
  value = module.bastion.bastion_public_ip
}
output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

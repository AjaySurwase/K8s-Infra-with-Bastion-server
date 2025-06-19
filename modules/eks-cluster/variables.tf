variable "cluster_name" {}
variable "cluster_role_arn" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  description = "List of security group IDs to associate with the EKS control plane"
  type        = list(string)
  default     = []
}

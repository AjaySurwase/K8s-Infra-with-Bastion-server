variable "cluster_name" {}
variable "node_role_arn" {}
variable "private_subnet_ids" {
  type = list(string)
}

variable "desired_capacity" {}
variable "min_capacity" {}
variable "max_capacity" {}

variable "instance_type" {}
variable "key_name" {}
variable "env" {}

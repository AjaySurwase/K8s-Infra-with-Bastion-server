# 🛡️ EKS Infrastructure with Bastion Host (Jump Server)

This project provisions a complete **Amazon EKS (Elastic Kubernetes Service)** cluster using **Terraform**, including a **bastion (jump) server** to access the Kubernetes cluster securely — following practices similar to MNC-level infrastructure design.

---

## 📌 Project Summary

We have implemented a production-style Kubernetes infrastructure on AWS that:

- Sets up a **VPC** with public and private subnets across 2 Availability Zones.
- Provisions a **bastion/jump EC2 server** in the public subnet to act as the gateway.
- Deploys an **EKS cluster** in the private subnets.
- Attaches a **Node Group** to the cluster in private subnets.
- Uses a **NAT Gateway** to allow private subnets outbound internet access.
- Configures **security groups** to control access between the bastion and the EKS control plane.

---

## 🔧 Technologies Used

- **Terraform** – Infrastructure as Code
- **AWS** – EC2, VPC, EKS, IAM, NAT Gateway, Security Groups
- **Kubernetes** – Cluster management
- **Amazon Linux 2** – Bastion EC2 host
- **kubectl** – To interact with the cluster
- **aws-cli v2** – AWS API operations

---

## 🧱 Infrastructure Architecture

### 🔹 VPC
- CIDR: `10.0.0.0/16`
- **Public Subnet**: for bastion host
- **Private Subnets**: for EKS control plane and worker nodes

### 🔹 Bastion Host
- EC2 instance in public subnet
- SSH key-based access
- Used to run `kubectl` to access private EKS API

### 🔹 EKS Cluster
- Version: `1.29`
- API endpoint: **Private only** (`endpoint_private_access = true`)
- Control plane in private subnet
- Cluster security group allows access only from within the VPC

### 🔹 Node Group
- EC2 worker nodes (Amazon Linux 2)
- Autoscaling with min/max/desired capacity
- IAM role for EKS nodes
- Deployed in private subnets

---

## 📂 Project Structure

EKS-INFRA/
├── environments/
│ └── prod/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ ├── terraform.tfvars
│ ├── iam-eks-role.tf
│ ├── iam-node-role.tf
│ ├── sg.tf
│ └── terraform.tfstate
├── modules/
│ ├── vpc/
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ ├── bastion/
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ ├── eks-cluster/
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ └── eks-node-group/
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
└── README.md
---

## ✅ Setup Instructions

### 1️⃣ Pre-requisites

- AWS CLI v2
- Terraform v1.5+
- IAM credentials with admin access
- A valid SSH key pair created in AWS

### 2️⃣ Clone the repo
```bash
git clone https://github.com/your-username/EKS-INFRA.git
cd EKS-INFRA/environments/prod
terraform init
terraform plan
terraform apply
aws eks update-kubeconfig --region us-east-1 --name prod-cluster
kubectl get nodes

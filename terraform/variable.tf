variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

# Your public IP in CIDR form, e.g. "203.0.113.10/32". Used for bastion SSH and the EKS public API.
variable "admin_cidr" {
  description = "CIDR allowed to SSH to the bastion and reach the EKS public API"
  type        = string

  validation {
    condition     = can(cidrhost(var.admin_cidr, 0)) && var.admin_cidr != "0.0.0.0/0"
    error_message = "admin_cidr must be a valid CIDR and must not be 0.0.0.0/0."
  }
}

# Bastion
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "storage" {
  description = "Bastion root volume size in GB"
  type        = number
  default     = 20
}

variable "public_key_path" {
  description = "Path to the SSH public key (generate with: ssh-keygen -t ed25519 -f bastion_key)"
  type        = string
  default     = "bastion_key.pub"
}

# VPC
variable "vpc_name" {
  type    = string
  default = "tws-auto-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["eu-north-2a", "eu-north-2b"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "intra_subnets" {
  description = "Subnets for the EKS control plane ENIs"
  type        = list(string)
  default     = ["10.0.51.0/24", "10.0.52.0/24"]
}

# EKS
variable "cluster_name" {
  type    = string
  default = "easyshop-eks"
}

variable "cluster_version" {
  description = "Kubernetes version; use a version currently supported by EKS"
  type        = string
  default     = "1.33"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium", "t3a.medium"]
}

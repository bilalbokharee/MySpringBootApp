# AWS region
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-west-2"
}

# VPC configuration
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

# Subnet tags
variable "private_subnet_tags" {
  description = "A map of tags to add to private subnets"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "A map of tags to add to public subnets"
  type        = map(string)
  default     = {}
}

# EKS cluster configuration
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.23"
}

variable "node_instance_type" {
  description = "Instance type for the EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_group_desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_group_max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "node_group_min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

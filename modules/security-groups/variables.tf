variable "project_name" {
  description = "Name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment such as dev, test or prod"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string
}
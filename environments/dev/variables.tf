variable "primary_region" {
  description = "Primary AWS region for the three-tier application"
  type        = string
  default     = "ap-south-1"
}

variable "dr_region" {
  description = "Disaster recovery region for the RDS read replica"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name used for tagging project resources"
  type        = string
  default     = "aws-3tier-devsecops"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "dev"
}
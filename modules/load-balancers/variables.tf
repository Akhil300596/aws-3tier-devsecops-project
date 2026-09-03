variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "ID of the project VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the internet-facing NLB"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "At least two public subnet IDs are required."
  }
}

variable "app_subnet_ids" {
  description = "Private application subnet IDs for the internal NLB"
  type        = list(string)

  validation {
    condition     = length(var.app_subnet_ids) >= 2
    error_message = "At least two application subnet IDs are required."
  }
}

variable "public_nlb_security_group_id" {
  description = "Security group ID for the public NLB"
  type        = string
}

variable "internal_nlb_security_group_id" {
  description = "Security group ID for the internal NLB"
  type        = string
}
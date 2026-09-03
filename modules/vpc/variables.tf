variable "project_name" {
  description = "Name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment such as dev, test or prod"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR range assigned to the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Two Availability Zones used by the project"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two Availability Zones must be provided."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR ranges for the two public subnets"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDRs must be provided."
  }
}

variable "web_subnet_cidrs" {
  description = "CIDR ranges for the two private web subnets"
  type        = list(string)

  validation {
    condition     = length(var.web_subnet_cidrs) == 2
    error_message = "Exactly two web subnet CIDRs must be provided."
  }
}

variable "app_subnet_cidrs" {
  description = "CIDR ranges for the two private application subnets"
  type        = list(string)

  validation {
    condition     = length(var.app_subnet_cidrs) == 2
    error_message = "Exactly two application subnet CIDRs must be provided."
  }
}

variable "db_subnet_cidrs" {
  description = "CIDR ranges for the two private database subnets"
  type        = list(string)

  validation {
    condition     = length(var.db_subnet_cidrs) == 2
    error_message = "Exactly two database subnet CIDRs must be provided."
  }
}
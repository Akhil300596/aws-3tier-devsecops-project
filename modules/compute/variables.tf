variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "web_subnet_ids" {
  description = "Private subnet IDs for the web Auto Scaling Group"
  type        = list(string)

  validation {
    condition     = length(var.web_subnet_ids) >= 2
    error_message = "At least two web subnet IDs are required."
  }
}

variable "app_subnet_ids" {
  description = "Private subnet IDs for the application Auto Scaling Group"
  type        = list(string)

  validation {
    condition     = length(var.app_subnet_ids) >= 2
    error_message = "At least two application subnet IDs are required."
  }
}

variable "web_security_group_id" {
  description = "Security group ID assigned to web instances"
  type        = string
}

variable "app_security_group_id" {
  description = "Security group ID assigned to application instances"
  type        = string
}

variable "web_instance_profile_name" {
  description = "IAM instance profile used by web instances"
  type        = string
}

variable "app_instance_profile_name" {
  description = "IAM instance profile used by application instances"
  type        = string
}

variable "web_target_group_arn" {
  description = "ARN of the web load-balancer target group"
  type        = string
}

variable "app_target_group_arn" {
  description = "ARN of the application load-balancer target group"
  type        = string
}

variable "internal_nlb_dns_name" {
  description = "Private DNS name of the internal Network Load Balancer"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type used by the web and application tiers"
  type        = string
  default     = "t3.micro"
}

variable "web_min_size" {
  description = "Minimum number of web instances"
  type        = number
  default     = 2
}

variable "web_desired_capacity" {
  description = "Desired number of web instances"
  type        = number
  default     = 2
}

variable "web_max_size" {
  description = "Maximum number of web instances"
  type        = number
  default     = 4
}

variable "app_min_size" {
  description = "Minimum number of application instances"
  type        = number
  default     = 2
}

variable "app_desired_capacity" {
  description = "Desired number of application instances"
  type        = number
  default     = 2
}

variable "app_max_size" {
  description = "Maximum number of application instances"
  type        = number
  default     = 4
}

variable "aws_region" {
  description = "AWS region containing the primary database and its secret"
  type        = string
}

variable "database_address" {
  description = "Private DNS address of the primary RDS database"
  type        = string
}

variable "database_port" {
  description = "Port used by the primary RDS database"
  type        = number
}

variable "database_name" {
  description = "Name of the application database"
  type        = string
}

variable "database_secret_arn" {
  description = "ARN of the Secrets Manager secret containing database credentials"
  type        = string
}
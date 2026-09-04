variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "web_autoscaling_group_name" {
  description = "Name of the web Auto Scaling Group"
  type        = string
}

variable "app_autoscaling_group_name" {
  description = "Name of the application Auto Scaling Group"
  type        = string
}

variable "public_nlb_arn" {
  description = "ARN of the public Network Load Balancer"
  type        = string
}

variable "internal_nlb_arn" {
  description = "ARN of the internal Network Load Balancer"
  type        = string
}

variable "web_target_group_arn" {
  description = "ARN of the web target group"
  type        = string
}

variable "app_target_group_arn" {
  description = "ARN of the application target group"
  type        = string
}

variable "primary_db_identifier" {
  description = "Identifier of the primary RDS database"
  type        = string
}

variable "dr_replica_identifier" {
  description = "Identifier of the cross-region RDS replica"
  type        = string
}

variable "cpu_threshold" {
  description = "CPU percentage that triggers a high-CPU alarm"
  type        = number
  default     = 80

  validation {
    condition     = var.cpu_threshold > 0 && var.cpu_threshold <= 100
    error_message = "CPU threshold must be between 1 and 100."
  }
}

variable "unhealthy_host_threshold" {
  description = "Number of unhealthy load-balancer targets that triggers an alarm"
  type        = number
  default     = 1
}

variable "free_storage_threshold_bytes" {
  description = "Minimum available RDS storage before an alarm is triggered"
  type        = number
  default     = 5368709120
}

variable "replica_lag_threshold_seconds" {
  description = "Maximum acceptable cross-region replication lag"
  type        = number
  default     = 60
}
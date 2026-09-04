variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "dr_vpc_cidr" {
  description = "CIDR block of the disaster recovery VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dr_availability_zones" {
  description = "Availability Zones used by the DR database subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.dr_availability_zones) >= 2
    error_message = "At least two DR Availability Zones are required."
  }
}

variable "dr_db_subnet_cidrs" {
  description = "CIDR blocks for the private DR database subnets"
  type        = list(string)
  default     = ["10.1.31.0/24", "10.1.32.0/24"]

  validation {
    condition     = length(var.dr_db_subnet_cidrs) == length(var.dr_availability_zones)
    error_message = "Provide one DR database subnet CIDR for each Availability Zone."
  }
}

variable "source_db_arn" {
  description = "ARN of the primary RDS database used as the replication source"
  type        = string
}

variable "replica_instance_class" {
  description = "Instance class used by the cross-region read replica"
  type        = string
  default     = "db.t3.micro"
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups for the replica"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "Backup retention must be between 1 and 35 days."
  }
}

variable "deletion_protection" {
  description = "Protect the replica from accidental deletion"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting the replica"
  type        = bool
  default     = true
}

variable "kms_deletion_window_days" {
  description = "Waiting period before deleting the DR KMS key"
  type        = number
  default     = 7

  validation {
    condition     = var.kms_deletion_window_days >= 7 && var.kms_deletion_window_days <= 30
    error_message = "The KMS deletion window must be between 7 and 30 days."
  }
}

variable "create_replica" {
  description = "Whether to create the cross-region RDS read replica"
  type        = bool
  default     = false
}
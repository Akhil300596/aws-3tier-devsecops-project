variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "db_subnet_ids" {
  description = "Private database subnet IDs"
  type        = list(string)

  validation {
    condition     = length(var.db_subnet_ids) >= 2
    error_message = "At least two database subnet IDs are required."
  }
}

variable "db_security_group_id" {
  description = "Security group assigned to the RDS database"
  type        = string
}

variable "database_name" {
  description = "Initial database created inside MySQL"
  type        = string
  default     = "applicationdb"
}

variable "master_username" {
  description = "RDS master username"
  type        = string
  default     = "dbadmin"
}

variable "engine_version" {
  description = "MySQL major engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial database storage in GiB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage allowed through autoscaling"
  type        = number
  default     = 100
}

variable "backup_retention_period" {
  description = "Number of days automated backups are retained"
  type        = number
  default     = 7
}

variable "multi_az" {
  description = "Whether the primary database uses Multi-AZ"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Protect the database from accidental deletion"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip the final snapshot when deleting the lab database"
  type        = bool
  default     = true
}
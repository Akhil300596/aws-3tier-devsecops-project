variable "aws_region" {
  description = "AWS region where the Terraform state bucket will be created"
  type        = string
  default     = "ap-south-1"
}

variable "state_bucket_name" {
  description = "Globally unique name of the Terraform state bucket"
  type        = string
  default     = "akhil-3tier-terraform-state-697858907754"
}
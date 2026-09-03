output "state_bucket_name" {
  description = "Name of the S3 bucket storing Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_region" {
  description = "Region of the Terraform state bucket"
  value       = var.aws_region
}

output "state_bucket_arn" {
  description = "ARN of the Terraform state bucket"
  value       = aws_s3_bucket.terraform_state.arn
}
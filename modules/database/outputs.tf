output "primary_db_identifier" {
  description = "Identifier of the primary RDS database"
  value       = aws_db_instance.primary.identifier
}

output "primary_db_arn" {
  description = "ARN of the primary RDS database"
  value       = aws_db_instance.primary.arn
}

output "primary_db_address" {
  description = "Private DNS address of the primary database"
  value       = aws_db_instance.primary.address
}

output "primary_db_endpoint" {
  description = "Private database endpoint including port"
  value       = aws_db_instance.primary.endpoint
}

output "primary_db_port" {
  description = "MySQL database port"
  value       = aws_db_instance.primary.port
}

output "master_secret_arn" {
  description = "ARN of the AWS-managed Secrets Manager secret"
  value       = try(aws_db_instance.primary.master_user_secret[0].secret_arn, null)
}
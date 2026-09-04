output "dr_vpc_id" {
  description = "ID of the disaster recovery VPC"
  value       = aws_vpc.dr.id
}

output "dr_database_subnet_ids" {
  description = "IDs of the private DR database subnets"
  value       = aws_subnet.dr_database[*].id
}

output "dr_database_security_group_id" {
  description = "Security group ID assigned to the DR database"
  value       = aws_security_group.dr_database.id
}

output "dr_kms_key_arn" {
  description = "ARN of the KMS key encrypting the DR database"
  value       = aws_kms_key.dr_database.arn
}

output "dr_replica_identifier" {
  description = "Identifier of the cross-region RDS read replica"
  value       = aws_db_instance.replica.identifier
}

output "dr_replica_arn" {
  description = "ARN of the cross-region RDS read replica"
  value       = aws_db_instance.replica.arn
}

output "dr_replica_address" {
  description = "Private DNS address of the cross-region RDS read replica"
  value       = aws_db_instance.replica.address
}

output "dr_replica_endpoint" {
  description = "Private endpoint and port of the cross-region RDS read replica"
  value       = aws_db_instance.replica.endpoint
}
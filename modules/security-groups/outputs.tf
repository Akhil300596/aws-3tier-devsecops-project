output "public_nlb_security_group_id" {
  description = "Security group ID of the public Network Load Balancer"
  value       = aws_security_group.public_nlb.id
}

output "web_security_group_id" {
  description = "Security group ID of the web Auto Scaling Group"
  value       = aws_security_group.web.id
}

output "internal_nlb_security_group_id" {
  description = "Security group ID of the internal Network Load Balancer"
  value       = aws_security_group.internal_nlb.id
}

output "app_security_group_id" {
  description = "Security group ID of the application Auto Scaling Group"
  value       = aws_security_group.app.id
}

output "db_security_group_id" {
  description = "Security group ID of the RDS database"
  value       = aws_security_group.db.id
}
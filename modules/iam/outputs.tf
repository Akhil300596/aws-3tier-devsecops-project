output "web_role_name" {
  description = "Name of the web EC2 IAM role"
  value       = aws_iam_role.web.name
}

output "web_role_arn" {
  description = "ARN of the web EC2 IAM role"
  value       = aws_iam_role.web.arn
}

output "web_instance_profile_name" {
  description = "Instance profile used by web launch templates"
  value       = aws_iam_instance_profile.web.name
}

output "app_role_name" {
  description = "Name of the application EC2 IAM role"
  value       = aws_iam_role.app.name
}

output "app_role_arn" {
  description = "ARN of the application EC2 IAM role"
  value       = aws_iam_role.app.arn
}

output "app_instance_profile_name" {
  description = "Instance profile used by application launch templates"
  value       = aws_iam_instance_profile.app.name
}
output "ubuntu_ami_id" {
  description = "Ubuntu AMI ID used by the launch templates"
  value       = data.aws_ami.ubuntu.id
}

output "web_launch_template_id" {
  description = "ID of the web launch template"
  value       = aws_launch_template.web.id
}

output "app_launch_template_id" {
  description = "ID of the application launch template"
  value       = aws_launch_template.app.id
}

output "web_autoscaling_group_name" {
  description = "Name of the web Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}

output "app_autoscaling_group_name" {
  description = "Name of the application Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}
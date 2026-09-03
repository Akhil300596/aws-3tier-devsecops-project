output "public_nlb_arn" {
  description = "ARN of the public Network Load Balancer"
  value       = aws_lb.public.arn
}

output "public_nlb_dns_name" {
  description = "DNS name of the public Network Load Balancer"
  value       = aws_lb.public.dns_name
}

output "public_nlb_zone_id" {
  description = "Route 53 zone ID of the public NLB"
  value       = aws_lb.public.zone_id
}

output "web_target_group_arn" {
  description = "ARN of the web target group"
  value       = aws_lb_target_group.web.arn
}

output "internal_nlb_arn" {
  description = "ARN of the internal Network Load Balancer"
  value       = aws_lb.internal.arn
}

output "internal_nlb_dns_name" {
  description = "Private DNS name of the internal NLB"
  value       = aws_lb.internal.dns_name
}

output "app_target_group_arn" {
  description = "ARN of the application target group"
  value       = aws_lb_target_group.app.arn
}
output "primary_sns_topic_arn" {
  description = "ARN of the primary-region monitoring notification topic"
  value       = aws_sns_topic.primary_alerts.arn
}

output "dr_sns_topic_arn" {
  description = "ARN of the disaster-recovery monitoring notification topic"
  value       = aws_sns_topic.dr_alerts.arn
}

output "primary_alarm_names" {
  description = "Names of the primary-region CloudWatch alarms"
  value = [
    aws_cloudwatch_metric_alarm.web_cpu_high.alarm_name,
    aws_cloudwatch_metric_alarm.app_cpu_high.alarm_name,
    aws_cloudwatch_metric_alarm.public_nlb_unhealthy_hosts.alarm_name,
    aws_cloudwatch_metric_alarm.internal_nlb_unhealthy_hosts.alarm_name,
    aws_cloudwatch_metric_alarm.primary_db_cpu_high.alarm_name,
    aws_cloudwatch_metric_alarm.primary_db_storage_low.alarm_name
  ]
}

output "dr_alarm_names" {
  description = "Names of the disaster-recovery CloudWatch alarms"
  value = [
    aws_cloudwatch_metric_alarm.dr_db_cpu_high.alarm_name,
    aws_cloudwatch_metric_alarm.dr_db_storage_low.alarm_name,
    aws_cloudwatch_metric_alarm.dr_replica_lag_high.alarm_name
  ]
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      configuration_aliases = [
        aws.dr
      ]
    }
  }
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  public_nlb_suffix   = trimprefix(split(":", var.public_nlb_arn)[5], "loadbalancer/")
  internal_nlb_suffix = trimprefix(split(":", var.internal_nlb_arn)[5], "loadbalancer/")
  web_tg_suffix       = split(":", var.web_target_group_arn)[5]
  app_tg_suffix       = split(":", var.app_target_group_arn)[5]

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_sns_topic" "primary_alerts" {
  name = "${local.name_prefix}-primary-alerts"

  tags = merge(local.common_tags, {
    Name   = "${local.name_prefix}-primary-alerts"
    Region = "primary"
  })
}

resource "aws_sns_topic" "dr_alerts" {
  provider = aws.dr

  name = "${local.name_prefix}-dr-alerts"

  tags = merge(local.common_tags, {
    Name   = "${local.name_prefix}-dr-alerts"
    Region = "disaster-recovery"
  })
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_high" {
  alarm_name        = "${local.name_prefix}-web-cpu-high"
  alarm_description = "Web tier average CPU utilization is too high"

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.cpu_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = var.web_autoscaling_group_name
  }

  alarm_actions = [aws_sns_topic.primary_alerts.arn]
  ok_actions    = [aws_sns_topic.primary_alerts.arn]

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_high" {
  alarm_name        = "${local.name_prefix}-app-cpu-high"
  alarm_description = "Application tier average CPU utilization is too high"

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.cpu_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = var.app_autoscaling_group_name
  }

  alarm_actions = [aws_sns_topic.primary_alerts.arn]
  ok_actions    = [aws_sns_topic.primary_alerts.arn]

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "public_nlb_unhealthy_hosts" {
  alarm_name        = "${local.name_prefix}-public-nlb-unhealthy-hosts"
  alarm_description = "The public NLB has unhealthy web targets"

  namespace   = "AWS/NetworkELB"
  metric_name = "UnHealthyHostCount"
  statistic   = "Maximum"

  period              = 60
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.unhealthy_host_threshold
  treat_missing_data  = "breaching"

  dimensions = {
    LoadBalancer = local.public_nlb_suffix
    TargetGroup  = local.web_tg_suffix
  }

  alarm_actions = [aws_sns_topic.primary_alerts.arn]
  ok_actions    = [aws_sns_topic.primary_alerts.arn]

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "internal_nlb_unhealthy_hosts" {
  alarm_name        = "${local.name_prefix}-internal-nlb-unhealthy-hosts"
  alarm_description = "The internal NLB has unhealthy application targets"

  namespace   = "AWS/NetworkELB"
  metric_name = "UnHealthyHostCount"
  statistic   = "Maximum"

  period              = 60
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.unhealthy_host_threshold
  treat_missing_data  = "breaching"

  dimensions = {
    LoadBalancer = local.internal_nlb_suffix
    TargetGroup  = local.app_tg_suffix
  }

  alarm_actions = [aws_sns_topic.primary_alerts.arn]
  ok_actions    = [aws_sns_topic.primary_alerts.arn]

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "primary_db_cpu_high" {
  alarm_name        = "${local.name_prefix}-primary-db-cpu-high"
  alarm_description = "Primary RDS CPU utilization is too high"

  namespace   = "AWS/RDS"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.cpu_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = var.primary_db_identifier
  }

  alarm_actions = [aws_sns_topic.primary_alerts.arn]
  ok_actions    = [aws_sns_topic.primary_alerts.arn]

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "primary_db_storage_low" {
  alarm_name        = "${local.name_prefix}-primary-db-storage-low"
  alarm_description = "Primary RDS available storage is too low"

  namespace   = "AWS/RDS"
  metric_name = "FreeStorageSpace"
  statistic   = "Average"

  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = var.free_storage_threshold_bytes
  treat_missing_data  = "breaching"

  dimensions = {
    DBInstanceIdentifier = var.primary_db_identifier
  }

  alarm_actions = [aws_sns_topic.primary_alerts.arn]
  ok_actions    = [aws_sns_topic.primary_alerts.arn]

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "dr_db_cpu_high" {
  provider = aws.dr

  alarm_name        = "${local.name_prefix}-dr-db-cpu-high"
  alarm_description = "DR RDS replica CPU utilization is too high"

  namespace   = "AWS/RDS"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.cpu_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = var.dr_replica_identifier
  }

  alarm_actions = [aws_sns_topic.dr_alerts.arn]
  ok_actions    = [aws_sns_topic.dr_alerts.arn]

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "dr_db_storage_low" {
  provider = aws.dr

  alarm_name        = "${local.name_prefix}-dr-db-storage-low"
  alarm_description = "DR RDS replica available storage is too low"

  namespace   = "AWS/RDS"
  metric_name = "FreeStorageSpace"
  statistic   = "Average"

  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = var.free_storage_threshold_bytes
  treat_missing_data  = "breaching"

  dimensions = {
    DBInstanceIdentifier = var.dr_replica_identifier
  }

  alarm_actions = [aws_sns_topic.dr_alerts.arn]
  ok_actions    = [aws_sns_topic.dr_alerts.arn]

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "dr_replica_lag_high" {
  provider = aws.dr

  alarm_name        = "${local.name_prefix}-dr-replica-lag-high"
  alarm_description = "Cross-region RDS replication lag is too high"

  namespace   = "AWS/RDS"
  metric_name = "ReplicaLag"
  statistic   = "Maximum"

  period              = 60
  evaluation_periods  = 3
  datapoints_to_alarm = 3

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.replica_lag_threshold_seconds
  treat_missing_data  = "breaching"

  dimensions = {
    DBInstanceIdentifier = var.dr_replica_identifier
  }

  alarm_actions = [aws_sns_topic.dr_alerts.arn]
  ok_actions    = [aws_sns_topic.dr_alerts.arn]

  tags = local.common_tags
}
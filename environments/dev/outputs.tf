output "vpc_id" {
  description = "ID of the project VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR range of the project VPC"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "web_subnet_ids" {
  description = "IDs of the private web subnets"
  value       = module.vpc.web_subnet_ids
}

output "app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = module.vpc.app_subnet_ids
}

output "db_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = module.vpc.db_subnet_ids
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.vpc.public_route_table_id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "nat_gateway_public_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = module.vpc.nat_gateway_public_ip
}

output "web_route_table_id" {
  description = "ID of the web route table"
  value       = module.vpc.web_route_table_id
}

output "app_route_table_id" {
  description = "ID of the application route table"
  value       = module.vpc.app_route_table_id
}

output "db_route_table_id" {
  description = "ID of the database route table"
  value       = module.vpc.db_route_table_id
}

output "public_nlb_security_group_id" {
  description = "Security group ID of the public NLB"
  value       = module.security_groups.public_nlb_security_group_id
}

output "web_security_group_id" {
  description = "Security group ID of the web tier"
  value       = module.security_groups.web_security_group_id
}

output "internal_nlb_security_group_id" {
  description = "Security group ID of the internal NLB"
  value       = module.security_groups.internal_nlb_security_group_id
}

output "app_security_group_id" {
  description = "Security group ID of the application tier"
  value       = module.security_groups.app_security_group_id
}

output "db_security_group_id" {
  description = "Security group ID of the database tier"
  value       = module.security_groups.db_security_group_id
}

output "web_iam_role_name" {
  description = "IAM role used by web instances"
  value       = module.iam.web_role_name
}

output "web_instance_profile_name" {
  description = "Instance profile used by web instances"
  value       = module.iam.web_instance_profile_name
}

output "app_iam_role_name" {
  description = "IAM role used by application instances"
  value       = module.iam.app_role_name
}

output "app_instance_profile_name" {
  description = "Instance profile used by application instances"
  value       = module.iam.app_instance_profile_name
}

output "public_nlb_dns_name" {
  description = "Public Network Load Balancer DNS name"
  value       = module.load_balancers.public_nlb_dns_name
}

output "internal_nlb_dns_name" {
  description = "Internal Network Load Balancer DNS name"
  value       = module.load_balancers.internal_nlb_dns_name
}

output "web_target_group_arn" {
  description = "Web-tier target group ARN"
  value       = module.load_balancers.web_target_group_arn
}

output "app_target_group_arn" {
  description = "Application-tier target group ARN"
  value       = module.load_balancers.app_target_group_arn
}

output "compute_ubuntu_ami_id" {
  description = "Ubuntu AMI used by the compute tiers"
  value       = module.compute.ubuntu_ami_id
}

output "web_launch_template_id" {
  description = "Web launch template ID"
  value       = module.compute.web_launch_template_id
}

output "app_launch_template_id" {
  description = "Application launch template ID"
  value       = module.compute.app_launch_template_id
}

output "web_autoscaling_group_name" {
  description = "Web Auto Scaling Group name"
  value       = module.compute.web_autoscaling_group_name
}

output "app_autoscaling_group_name" {
  description = "Application Auto Scaling Group name"
  value       = module.compute.app_autoscaling_group_name
}

output "database_master_secret_arn" {
  description = "ARN of the AWS-managed database credential secret"
  value       = module.database.master_secret_arn
}

output "primary_db_identifier" {
  description = "Primary RDS database identifier"
  value       = module.database.primary_db_identifier
}

output "primary_db_address" {
  description = "Private DNS address of the primary database"
  value       = module.database.primary_db_address
}

output "primary_db_endpoint" {
  description = "Primary database endpoint and port"
  value       = module.database.primary_db_endpoint
}

output "primary_db_port" {
  description = "Primary database port"
  value       = module.database.primary_db_port
}

output "dr_vpc_id" {
  description = "ID of the disaster recovery VPC"
  value       = module.disaster_recovery.dr_vpc_id
}

output "dr_database_subnet_ids" {
  description = "IDs of the private disaster recovery database subnets"
  value       = module.disaster_recovery.dr_database_subnet_ids
}

output "dr_database_security_group_id" {
  description = "Security group ID of the disaster recovery database"
  value       = module.disaster_recovery.dr_database_security_group_id
}

output "dr_kms_key_arn" {
  description = "ARN of the KMS key protecting the DR replica"
  value       = module.disaster_recovery.dr_kms_key_arn
}

output "dr_replica_identifier" {
  description = "Identifier of the cross-region RDS replica"
  value       = module.disaster_recovery.dr_replica_identifier
}

output "dr_replica_arn" {
  description = "ARN of the cross-region RDS replica"
  value       = module.disaster_recovery.dr_replica_arn
}

output "dr_replica_address" {
  description = "Private DNS address of the cross-region RDS replica"
  value       = module.disaster_recovery.dr_replica_address
}

output "dr_replica_endpoint" {
  description = "Private endpoint of the cross-region RDS replica"
  value       = module.disaster_recovery.dr_replica_endpoint
}

output "primary_monitoring_sns_topic_arn" {
  description = "ARN of the primary-region monitoring SNS topic"
  value       = module.monitoring.primary_sns_topic_arn
}

output "dr_monitoring_sns_topic_arn" {
  description = "ARN of the DR-region monitoring SNS topic"
  value       = module.monitoring.dr_sns_topic_arn
}

output "primary_cloudwatch_alarm_names" {
  description = "Names of the primary-region CloudWatch alarms"
  value       = module.monitoring.primary_alarm_names
}

output "dr_cloudwatch_alarm_names" {
  description = "Names of the DR-region CloudWatch alarms"
  value       = module.monitoring.dr_alarm_names
}
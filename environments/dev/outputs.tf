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

output "vpc_id" {
  description = "ID of the project VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR range of the project VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "web_subnet_ids" {
  description = "IDs of the private web subnets"
  value       = aws_subnet.web[*].id
}

output "app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = aws_subnet.app[*].id
}

output "db_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = aws_subnet.db[*].id
}

output "availability_zones" {
  description = "Availability Zones used by the VPC"
  value       = var.availability_zones
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway attached to the VPC"
  value       = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "nat_gateway_id" {
  description = "ID of the development NAT Gateway"
  value       = aws_nat_gateway.this.id
}

output "nat_gateway_public_ip" {
  description = "Public Elastic IP assigned to the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "web_route_table_id" {
  description = "ID of the private web route table"
  value       = aws_route_table.web.id
}

output "app_route_table_id" {
  description = "ID of the private application route table"
  value       = aws_route_table.app.id
}

output "db_route_table_id" {
  description = "ID of the isolated database route table"
  value       = aws_route_table.db.id
}
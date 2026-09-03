locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group" "public_nlb" {
  name        = "${var.project_name}-${var.environment}-public-nlb-sg"
  description = "Security group for the internet-facing Network Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-public-nlb-sg"
    Tier = "public-load-balancer"
  })
}

resource "aws_security_group" "web" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "Security group for the web Auto Scaling Group"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-sg"
    Tier = "web"
  })
}

resource "aws_security_group" "internal_nlb" {
  name        = "${var.project_name}-${var.environment}-internal-nlb-sg"
  description = "Security group for the internal Network Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-internal-nlb-sg"
    Tier = "internal-load-balancer"
  })
}

resource "aws_security_group" "app" {
  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "Security group for the application Auto Scaling Group"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-app-sg"
    Tier = "application"
  })
}

resource "aws_security_group" "db" {
  name        = "${var.project_name}-${var.environment}-db-sg"
  description = "Security group for the RDS database"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-db-sg"
    Tier = "database"
  })
}
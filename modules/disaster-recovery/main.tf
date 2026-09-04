terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_vpc" "dr" {
  cidr_block           = var.dr_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name_prefix}-dr-vpc"
    Tier = "database"
    Role = "disaster-recovery"
  }
}

resource "aws_subnet" "dr_database" {
  count = length(var.dr_db_subnet_cidrs)

  vpc_id                  = aws_vpc.dr.id
  cidr_block              = var.dr_db_subnet_cidrs[count.index]
  availability_zone       = var.dr_availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name_prefix}-dr-db-${count.index + 1}"
    Tier = "database"
    Role = "disaster-recovery"
  }
}

resource "aws_route_table" "dr_database" {
  vpc_id = aws_vpc.dr.id

  tags = {
    Name = "${local.name_prefix}-dr-db-rt"
    Tier = "database"
    Role = "disaster-recovery"
  }
}

resource "aws_route_table_association" "dr_database" {
  count = length(aws_subnet.dr_database)

  subnet_id      = aws_subnet.dr_database[count.index].id
  route_table_id = aws_route_table.dr_database.id
}

resource "aws_security_group" "dr_database" {
  name        = "${local.name_prefix}-dr-db-sg"
  description = "Security group for the disaster recovery RDS replica"
  vpc_id      = aws_vpc.dr.id

  tags = {
    Name = "${local.name_prefix}-dr-db-sg"
    Tier = "database"
    Role = "disaster-recovery"
  }
}

resource "aws_kms_key" "dr_database" {
  description             = "KMS key for the encrypted cross-region RDS replica"
  deletion_window_in_days = var.kms_deletion_window_days
  enable_key_rotation     = true

  tags = {
    Name = "${local.name_prefix}-dr-rds-key"
    Tier = "database"
    Role = "disaster-recovery"
  }
}

resource "aws_kms_alias" "dr_database" {
  name          = "alias/${local.name_prefix}-dr-rds"
  target_key_id = aws_kms_key.dr_database.key_id
}

resource "aws_db_subnet_group" "dr" {
  name       = "${local.name_prefix}-dr-db-subnet-group"
  subnet_ids = aws_subnet.dr_database[*].id

  tags = {
    Name = "${local.name_prefix}-dr-db-subnet-group"
    Tier = "database"
    Role = "disaster-recovery"
  }
}

resource "aws_db_instance" "replica" {
  count      = var.create_replica ? 1 : 0
  identifier = "${local.name_prefix}-mysql-dr-replica"

  replicate_source_db = var.source_db_arn
  instance_class      = var.replica_instance_class

  db_subnet_group_name   = aws_db_subnet_group.dr.name
  vpc_security_group_ids = [aws_security_group.dr_database.id]

  publicly_accessible = false
  multi_az            = false

  storage_encrypted = true
  kms_key_id        = aws_kms_key.dr_database.arn

  backup_retention_period    = var.backup_retention_period
  copy_tags_to_snapshot      = true
  auto_minor_version_upgrade = true

  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  final_snapshot_identifier = var.skip_final_snapshot ? null : "${local.name_prefix}-mysql-dr-final"

  apply_immediately = true

  tags = {
    Name = "${local.name_prefix}-mysql-dr-replica"
    Tier = "database"
    Role = "disaster-recovery"
  }

  depends_on = [
    aws_kms_alias.dr_database
  ]
}
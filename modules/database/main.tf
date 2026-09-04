locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "random_password" "master" {
  length = 24

  special          = true
  override_special = "!#$%&*()-_=+[]{}:,.?"

  min_lower   = 2
  min_upper   = 2
  min_numeric = 2
  min_special = 2
}

resource "aws_secretsmanager_secret" "database_master" {
  name                    = "${local.name_prefix}-database-master"
  description             = "Master credentials for the primary application database"
  recovery_window_in_days = 7

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-database-master"
    Tier = "database"
  })
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-subnet-group"
    Tier = "database"
  })
}

resource "aws_db_instance" "primary" {
  identifier = "a3d-${var.environment}-mysql-primary"

  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class

  db_name  = var.database_name
  username = var.master_username
  port     = 3306

  password = random_password.master.result

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_security_group_id]
  publicly_accessible    = false
  multi_az               = var.multi_az

  backup_retention_period = var.backup_retention_period
  backup_window           = "18:00-19:00"
  maintenance_window      = "sun:19:00-sun:20:00"

  copy_tags_to_snapshot       = true
  delete_automated_backups    = true
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false
  apply_immediately           = true

  enabled_cloudwatch_logs_exports = ["error"]

  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-mysql-primary"
    Tier = "database"
    Role = "primary"
  })

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_secretsmanager_secret_version" "database_master" {
  secret_id = aws_secretsmanager_secret.database_master.id

  secret_string = jsonencode({
    username             = var.master_username
    password             = random_password.master.result
    engine               = "mysql"
    host                 = aws_db_instance.primary.address
    port                 = aws_db_instance.primary.port
    dbname               = aws_db_instance.primary.db_name
    dbInstanceIdentifier = aws_db_instance.primary.identifier
  })
}
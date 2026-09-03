locals {
  name_prefix     = "${var.project_name}-${var.environment}"
  resource_prefix = "a3d-${var.environment}"
}

resource "aws_lb" "public" {
  name               = "${local.resource_prefix}-public-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnet_ids
  security_groups    = [var.public_nlb_security_group_id]

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false

  tags = {
    Name        = "${local.name_prefix}-public-nlb"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "web"
  }
}

resource "aws_lb_target_group" "web" {
  name        = "${local.resource_prefix}-web-tg"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    protocol            = "TCP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
  }

  tags = {
    Name        = "${local.name_prefix}-web-tg"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "web"
  }
}

resource "aws_lb_listener" "public" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb" "internal" {
  name               = "${local.resource_prefix}-internal-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.app_subnet_ids
  security_groups    = [var.internal_nlb_security_group_id]

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false

  tags = {
    Name        = "${local.name_prefix}-internal-nlb"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "application"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "${local.resource_prefix}-app-tg"
  port        = 8080
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    protocol            = "TCP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
  }

  tags = {
    Name        = "${local.name_prefix}-app-tg"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Tier        = "application"
  }
}

resource "aws_lb_listener" "internal" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 8080
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
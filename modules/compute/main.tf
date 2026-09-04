locals {
  name_prefix     = "${var.project_name}-${var.environment}"
  resource_prefix = "a3d-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_launch_template" "web" {
  name_prefix   = "${local.resource_prefix}-web-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.web_security_group_id]

  iam_instance_profile {
    name = var.web_instance_profile_name
  }

  user_data = base64encode(templatefile(
    "${path.module}/templates/web-user-data.sh",
    {
      internal_nlb_dns_name = var.internal_nlb_dns_name
    }
  ))

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 12
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = false
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-web"
      Tier = "web"
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-web-volume"
      Tier = "web"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-web-launch-template"
    Tier = "web"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "${local.resource_prefix}-app-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.app_security_group_id]

  iam_instance_profile {
    name = var.app_instance_profile_name
  }

  user_data = base64encode(
    templatefile("${path.module}/templates/app-user-data.sh", {
      aws_region          = var.aws_region
      database_address    = var.database_address
      database_port       = var.database_port
      database_name       = var.database_name
      database_secret_arn = var.database_secret_arn
    })
  )

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 12
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = false
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-app"
      Tier = "application"
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-app-volume"
      Tier = "application"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-app-launch-template"
    Tier = "application"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name = "${local.resource_prefix}-web-asg"

  min_size         = var.web_min_size
  desired_capacity = var.web_desired_capacity
  max_size         = var.web_max_size

  vpc_zone_identifier = var.web_subnet_ids
  target_group_arns   = [var.web_target_group_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300
  wait_for_capacity_timeout = "20m"

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 180
    }

    triggers = ["tag"]
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-web"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "terraform"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "web"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "app" {
  name = "${local.resource_prefix}-app-asg"

  min_size         = var.app_min_size
  desired_capacity = var.app_desired_capacity
  max_size         = var.app_max_size

  vpc_zone_identifier = var.app_subnet_ids
  target_group_arns   = [var.app_target_group_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300
  wait_for_capacity_timeout = "20m"

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 180
    }

    triggers = ["tag"]
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-app"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "terraform"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "application"
    propagate_at_launch = true
  }
}
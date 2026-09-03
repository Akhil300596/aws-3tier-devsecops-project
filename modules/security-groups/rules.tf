resource "aws_vpc_security_group_ingress_rule" "public_nlb_http" {
  security_group_id = aws_security_group.public_nlb.id

  description = "Allow HTTP traffic from the internet"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "public_nlb_to_web" {
  security_group_id = aws_security_group.public_nlb.id

  description                  = "Allow public NLB to reach web instances"
  referenced_security_group_id = aws_security_group.web.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}


resource "aws_vpc_security_group_ingress_rule" "web_from_public_nlb" {
  security_group_id = aws_security_group.web.id

  description                  = "Allow HTTP only from the public NLB"
  referenced_security_group_id = aws_security_group.public_nlb.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "web_to_internal_nlb" {
  security_group_id = aws_security_group.web.id

  description                  = "Allow web instances to reach the internal NLB"
  referenced_security_group_id = aws_security_group.internal_nlb.id
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
}

resource "aws_vpc_security_group_egress_rule" "web_http_outbound" {
  security_group_id = aws_security_group.web.id

  description = "Allow web instances to download packages over HTTP"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "web_https_outbound" {
  security_group_id = aws_security_group.web.id

  description = "Allow web instances to access AWS services and repositories over HTTPS"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

resource "aws_vpc_security_group_ingress_rule" "internal_nlb_from_web" {
  security_group_id = aws_security_group.internal_nlb.id

  description                  = "Allow application traffic only from the web tier"
  referenced_security_group_id = aws_security_group.web.id
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
}

resource "aws_vpc_security_group_egress_rule" "internal_nlb_to_app" {
  security_group_id = aws_security_group.internal_nlb.id

  description                  = "Allow internal NLB to reach application instances"
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
}

resource "aws_vpc_security_group_ingress_rule" "app_from_internal_nlb" {
  security_group_id = aws_security_group.app.id

  description                  = "Allow application traffic only from the internal NLB"
  referenced_security_group_id = aws_security_group.internal_nlb.id
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
}

resource "aws_vpc_security_group_egress_rule" "app_to_db" {
  security_group_id = aws_security_group.app.id

  description                  = "Allow application instances to connect to MySQL"
  referenced_security_group_id = aws_security_group.db.id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
}

resource "aws_vpc_security_group_egress_rule" "app_http_outbound" {
  security_group_id = aws_security_group.app.id

  description = "Allow application instances to download packages over HTTP"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "app_https_outbound" {
  security_group_id = aws_security_group.app.id

  description = "Allow application instances to access AWS services over HTTPS"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id = aws_security_group.db.id

  description                  = "Allow MySQL connections only from application instances"
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
}


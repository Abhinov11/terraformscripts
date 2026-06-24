#Bastion Security Group
resource "aws_security_group" "bastion" {

  name        = "${var.project_name}-${var.environment}-bastion-sg"

  description = "Bastion Host Security Group"

  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-bastion-sg"
  }
}

#Bastion Ingress
resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {

  security_group_id = aws_security_group.bastion.id

  cidr_ipv4 = var.admin_ip

  from_port = 22

  to_port = 22

  ip_protocol = "tcp"
}

#Bastion Egress
resource "aws_vpc_security_group_egress_rule" "bastion_egress" {

  security_group_id = aws_security_group.bastion.id

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "-1"
}

#Web Security Group
resource "aws_security_group" "web" {

  name        = "${var.project_name}-${var.environment}-web-sg"

  description = "Web Tier Security Group"

  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-web-sg"
  }
}

#HTTP
resource "aws_vpc_security_group_ingress_rule" "web_http" {

  security_group_id = aws_security_group.web.id

  cidr_ipv4 = "0.0.0.0/0"

  from_port = 80

  to_port = 80

  ip_protocol = "tcp"
}

#HTTPS
resource "aws_vpc_security_group_ingress_rule" "web_https" {

  security_group_id = aws_security_group.web.id

  cidr_ipv4 = "0.0.0.0/0"

  from_port = 443

  to_port = 443

  ip_protocol = "tcp"
}

#SSH from Bastion Only
resource "aws_vpc_security_group_ingress_rule" "web_ssh" {

  security_group_id = aws_security_group.web.id

  referenced_security_group_id = aws_security_group.bastion.id

  from_port = 22

  to_port = 22

  ip_protocol = "tcp"
}

#Web Egress
resource "aws_vpc_security_group_egress_rule" "web_egress" {

  security_group_id = aws_security_group.web.id

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "-1"
}

#App Security Group
resource "aws_security_group" "app" {

  name        = "${var.project_name}-${var.environment}-app-sg"

  description = "Application Tier Security Group"

  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-app-sg"
  }
}

#App Port Access from Web Tier
resource "aws_vpc_security_group_ingress_rule" "app_8080" {

  security_group_id = aws_security_group.app.id

  referenced_security_group_id = aws_security_group.web.id

  from_port = 8080

  to_port = 8080

  ip_protocol = "tcp"
}

#SSH from Bastion
resource "aws_vpc_security_group_ingress_rule" "app_ssh" {

  security_group_id = aws_security_group.app.id

  referenced_security_group_id = aws_security_group.bastion.id

  from_port = 22

  to_port = 22

  ip_protocol = "tcp"
}

#App Egress
resource "aws_vpc_security_group_egress_rule" "app_egress" {

  security_group_id = aws_security_group.app.id

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "-1"
}

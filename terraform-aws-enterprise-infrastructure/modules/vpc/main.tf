#vpc
resource "aws_vpc" "this" {

  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

#internet gateway
resource "aws_internet_gateway" "this" {

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

#public subnet - 1
resource "aws_subnet" "public_1" {

  vpc_id = aws_vpc.this.id

  cidr_block = var.public_subnet_1_cidr

  availability_zone = var.az1

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-1"
  }
}

#public subnet - 2
resource "aws_subnet" "public_2" {

  vpc_id = aws_vpc.this.id

  cidr_block = var.public_subnet_2_cidr

  availability_zone = var.az2

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-2"
  }
}

#private subnet - 1
resource "aws_subnet" "private_1" {

  vpc_id = aws_vpc.this.id

  cidr_block = var.private_subnet_1_cidr

  availability_zone = var.az1

  tags = {
    Name = "${var.project_name}-${var.environment}-private-1"
  }
}

#private subnet - 2
resource "aws_subnet" "private_2" {

  vpc_id = aws_vpc.this.id

  cidr_block = var.private_subnet_2_cidr

  availability_zone = var.az2

  tags = {
    Name = "${var.project_name}-${var.environment}-private-2"
  }
}

#elastic IP
resource "aws_eip" "nat" {

  domain = "vpc"

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-eip"
  }
}

#NAT gateway
resource "aws_nat_gateway" "this" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public_1.id

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-nat"
  }
}

#Public Route Table
resource "aws_route_table" "public" {

  vpc_id = aws_vpc.this.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

#Private Route Table
resource "aws_route_table" "private" {

  vpc_id = aws_vpc.this.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt"
  }
}

#Route Associations
#Public 1
resource "aws_route_table_association" "public_1" {

  subnet_id = aws_subnet.public_1.id

  route_table_id = aws_route_table.public.id
}
#Public 2
resource "aws_route_table_association" "public_2" {

  subnet_id = aws_subnet.public_2.id

  route_table_id = aws_route_table.public.id
}
#Private 1
resource "aws_route_table_association" "private_1" {

  subnet_id = aws_subnet.private_1.id

  route_table_id = aws_route_table.private.id
}
#Private 2
resource "aws_route_table_association" "private_2" {

  subnet_id = aws_subnet.private_2.id

  route_table_id = aws_route_table.private.id
}

#Public NACL
resource "aws_network_acl" "public" {

  vpc_id = aws_vpc.this.id

  subnet_ids = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-public-nacl"
  }
}
#HTTP
resource "aws_network_acl_rule" "public_http" {

  network_acl_id = aws_network_acl.public.id

  rule_number = 100

  egress = false

  protocol = "tcp"

  rule_action = "allow"

  cidr_block = "0.0.0.0/0"

  from_port = 80

  to_port = 80
}
#HTTPS
resource "aws_network_acl_rule" "public_https" {

  network_acl_id = aws_network_acl.public.id

  rule_number = 110

  egress = false

  protocol = "tcp"

  rule_action = "allow"

  cidr_block = "0.0.0.0/0"

  from_port = 443

  to_port = 443
}
#Ephemeral Return Ports
resource "aws_network_acl_rule" "public_ephemeral" {

  network_acl_id = aws_network_acl.public.id

  rule_number = 120

  egress = false

  protocol = "tcp"

  rule_action = "allow"

  cidr_block = "0.0.0.0/0"

  from_port = 1024

  to_port = 65535
}

#Private NACL
resource "aws_network_acl" "private" {

  vpc_id = aws_vpc.this.id

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-nacl"
  }
}
#Allow Internal Traffic
resource "aws_network_acl_rule" "private_internal" {

  network_acl_id = aws_network_acl.private.id

  rule_number = 100

  egress = false

  protocol = "-1"

  rule_action = "allow"

  cidr_block = var.vpc_cidr
}
#Allow Return Traffic
resource "aws_network_acl_rule" "private_ephemeral" {

  network_acl_id = aws_network_acl.private.id

  rule_number = 110

  egress = false

  protocol = "tcp"

  rule_action = "allow"

  cidr_block = "0.0.0.0/0"

  from_port = 1024

  to_port = 65535
}
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


terraform {
  required_version = ">= 0.12"
}

resource "aws_vpc" "default" {
  cidr_block           = format("%s.0.0/16", var.vpc_sub)
  enable_dns_hostnames = true
  tags = {
    Name        =  var.name
    Description = "${var.name} - VPC"
  }
}
/*
  Public Subnet
*/
resource "aws_subnet" "public" {
  count =  length(var.az_zones)
  vpc_id = aws_vpc.default.id

  cidr_block        = cidrsubnet(format("%s.0.0/21", var.vpc_sub), ceil(log(length(var.az_zones), 2)), count.index)
  availability_zone = var.az_zones[count.index]

  tags = {
    Name        = "${var.name}-PubSubnet-${var.az_zones[count.index]}"
    Description = "Public Subnet"
  }
}
/*
  Private Subnet
*/

resource "aws_subnet" "private" {
  count =  length(var.az_zones)
  vpc_id = aws_vpc.default.id

  cidr_block        = cidrsubnet(format("%s.100.0/20", var.vpc_sub), ceil(log(length(var.az_zones), 2)), count.index)
  availability_zone = var.az_zones[count.index]

  tags = {
    Name        = "${var.name}-PrivSubnet-${var.az_zones[count.index]}"
    Description = "Private Subnet"
  }
}

/* Gateways Nat and Internet */
resource "aws_eip" "nat" {
  count = length(var.az_zones) 
  vpc = true
  tags = {
    Name        = "${var.name}-${var.az_zones[count.index]}"
    Description = "Internet Gateway for NAT Gateway"
  }
}
resource "aws_nat_gateway" "default" {
  count = length(var.az_zones) 
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_subnet.public]

  tags = {
    Name = "${var.name}-NatGW-${var.az_zones[count.index]}"
  }
}
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name        = "${var.name} - InternetGateway"
    Description = "Internet Gateway for Public Subnets"
  }
}
/* route tables */
resource "aws_route_table" "private" {
  count = length(var.az_zones) 
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.default.*.id, count.index)
  }

  tags = {
    Name        = "${var.name}-Private-${var.az_zones[count.index]}"
    Description = "Route table Target to Nat Gateway"
  }
  depends_on = [aws_nat_gateway.default]
}
resource "aws_route_table" "public" {
  count = length(var.az_zones) 
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name        = "${var.name}-Public-${var.az_zones[count.index]}"
    Description = "Route table Target to Internet Gateway"
  }
  depends_on = [aws_internet_gateway.default]
}
/* Subnets Assciation for Public and Private */
resource "aws_route_table_association" "private" {
  count = length(var.az_zones)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  depends_on = [
    aws_subnet.private,
    aws_route_table.private,
  ]
}
resource "aws_route_table_association" "public" {
  count = length(var.az_zones)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
  depends_on = [
    aws_subnet.public,
    aws_route_table.public,
  ]
}
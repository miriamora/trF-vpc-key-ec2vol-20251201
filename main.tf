resource "aws_vpc" "utc-vpc" {
  cidr_block           = "172.120.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy = "default"
  tags = {
    Name       = "utc-Vpc"
    env        = "Dev"
    app-name   = "utc"
    Team       = "wdp"
    created_by = "Me"
  }
}

resource "aws_internet_gateway" "utc-igW" {
  vpc_id = aws_vpc.utc-vpc.id
  tags = {
    Name = "Terraform-IGW"
  }
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.utc-vpc.id
  cidr_block        = "172.120.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "utc-public-sub1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.utc-vpc.id
  cidr_block        = "172.120.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "utc-public-sub2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.utc-vpc.id
  cidr_block        = "172.120.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "utc-private-sub1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.utc-vpc.id
  cidr_block        = "172.120.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "utc-private-sub2"
  }
}

#create NAT gateway
resource "aws_eip" "utc-elastic-ip" {
}

resource "aws_nat_gateway" "utc-NAT" {
  subnet_id     = aws_subnet.public1.id
  allocation_id = aws_eip.utc-elastic-ip.id
  tags = {
    Name = "utc-NAT"
  }
}

#create private route table
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.utc-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.utc-NAT.id
  }
}

#create public route table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.utc-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.utc-igW.id
  }
}

#associate private route tables to private subnets
resource "aws_route_table_association" "route-assoc-private-1" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private1.id
}
resource "aws_route_table_association" "route-assoc-private-2" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private2.id
}

#associate public route tables to private subnets
resource "aws_route_table_association" "route-assoc-public-1" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public1.id
}
resource "aws_route_table_association" "route-assoc-public-2" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public2.id
}

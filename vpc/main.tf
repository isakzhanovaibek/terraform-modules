
resource "aws_vpc" "main" {
  cidr_block                       = var.cidr_block_vpc
  enable_dns_support               = true
  enable_dns_hostnames             = true
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  assign_generated_ipv6_cidr_block = false
  tags = {
    Name = "Main_VPC"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_a
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-eu-central-1a"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_b
  availability_zone = "eu-central-1b"

  tags = {
    Name = "public-eu-central-1b"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_a
  availability_zone = "eu-central-1a"

  tags = {
    Name = "private-eu-central-1a"
     "kubernetes.io/cluster/eks"       = "shared"
     "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_b
  availability_zone = "eu-central-1b"

  tags = {
    Name = "private-eu-central-1b"
    "kubernetes.io/cluster/eks"       = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    name = "main"
  }
}

#=====================================================================================
resource "aws_eip" "nat1" {
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "nat1"
  }
}

resource "aws_eip" "nat2" {
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "nat2"
  }
}

resource "aws_nat_gateway" "gw1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "NAT 1"
  } 
}

resource "aws_nat_gateway" "gw2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "NAT 2"
  }
}

#======================================================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    name = "public"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id 
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw1.id
  }
  tags = {
    name = "private1"
  }
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.main.id 
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw2.id
  }
  tags = {
    name = "private2"
  }
}

#====================================================================================

resource "aws_route_table_association" "public-a" {
  subnet_id = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-b" {
  subnet_id = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-a" {
  subnet_id = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private-b" {
  subnet_id = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private2.id
}

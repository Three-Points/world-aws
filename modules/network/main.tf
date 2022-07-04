resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = {
    Name = "ThreePoints-VPC"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ThreePoints-InternetGateway"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Public-Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  depends_on        = [aws_vpc.vpc]
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private-Subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_vpc.vpc]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "Public-RouteTable"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_db_subnet_group" "private_subnet_db" {
  name       = "vpc-subnet-groups"
  description = "VPC Subnet Groups"
  subnet_ids = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]

  tags = {
    Name = "Private Subnet DB"
  }
}
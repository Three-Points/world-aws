resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ThreePoints"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ThreePoints-InternetGateway"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

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

// IM
resource "aws_security_group" "security_group_http" {
  name        = "Allow-HTTP-SG"
  description = "Allow HTTP inbound traffic"

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP"
  }
}

resource "aws_security_group" "security_group_ssh" {
  name        = "Allow-SSH-SG"
  description = "Allow SHH inbound traffic"

  ingress {
    description = "SHH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow SSH"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "PUBLIC_SSH_KEY"
}

resource "aws_instance" "ec2" {
  ami                         = "ami-0a874daec5f3f65de"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
  security_groups             = [
    aws_security_group.security_group_ssh.id,
    aws_security_group.security_group_http.id
  ]
  tags = {
    Name = "App-Server"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Private-Subnet"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "Private-RouteTable"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
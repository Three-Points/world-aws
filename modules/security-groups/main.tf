resource "aws_security_group" "security_group_application" {
  name        = "Public Security Group"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from anywhere"
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
    Name = "Application Security Group"
  }
}

resource "aws_security_group" "security_group_mysql" {
  name        = "Private Security Group"
  description = "Allow MySQL inbound traffic"
  vpc_id      = var.vpc

  ingress {
    description     = "MySQL from VPC"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.security_group_application.id]
  }

  tags = {
    Name = "Database Security Group"
  }
}
output "vpc" {
  description = "VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet" {
  description = "Public Subnet"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet" {
  description = "Private Subnet"
  value       = aws_subnet.private_subnet.id
}

output "private_subnet_db" {
  description = "Private Subnet DB"
  value       = aws_db_subnet_group.private_subnet_db.name
}
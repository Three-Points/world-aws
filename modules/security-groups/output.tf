output "security_group_application" {
  description = "Security Group Application"
  value       = aws_security_group.security_group_application.id
}

output "security_group_database" {
  description = "Security Group Database"
  value       = aws_security_group.security_group_mysql.id
}
output "aws_vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "app_security_group_id" {
  value = aws_security_group.app.id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.main.repository_url
}

output "vpc_flow_log_id" {
  value = aws_flow_log.main.id
}

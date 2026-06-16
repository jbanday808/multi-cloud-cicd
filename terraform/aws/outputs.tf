output "aws_vpc_id" {
  value = aws_vpc.main.id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.main.repository_url
}

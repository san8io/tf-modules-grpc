output "repo_name" {
  description = "AWS ECR repository name"
  value       = aws_ecr_repository.default.name
}

output "repo_uri" {
  description = "AWS ECR repository URI"
  value       = aws_ecr_repository.default.repository_url
}

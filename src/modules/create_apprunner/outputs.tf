output "apprunner_arn" {
  value = aws_apprunner_service.this.arn
}

output "apprunner_url" {
  value = aws_apprunner_service.this.service_url
}

output "ecr_name" {
  value = aws_ecr_repository.app.name
}

output "ecr_arn" {
  value = aws_ecr_repository.app.arn
}

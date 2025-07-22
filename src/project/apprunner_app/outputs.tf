# ---------------------------------------------
# 共通
# ---------------------------------------------
output "rds_dns_address" {
  value = module.rds.dns_address
}

output "region_id" {
  description = "The AWS region ID where the resources are deployed."
  value       = module.current_account.region_id
}

output "migration_lambda_function_name" {
  description = "The name of the Lambda function for database migration."
  value       = aws_lambda_function.migration_lambda.function_name
}

output "github_actions_iam_role" {
  description = "ARN of the IAM role for GitHub Actions to deploy to App Runner."
  value       = aws_iam_role.github_actions_role.arn
}

# ---------------------------------------------
# use front
# ---------------------------------------------
output "user_front_apprunner_service_url" {
  description = "The URL of the App Runner service."
  value       = module.user_front_apprunner.apprunner_service_url
}

output "user_front_ecr_name" {
  description = "The name of the ECR repository created by the module."
  value       = aws_ecr_repository.user_front_ecr.name
}

output "user_front_apprunner_arn" {
  description = "The arn of the App Runner service."
  value       = module.user_front_apprunner.apprunner_arn
}

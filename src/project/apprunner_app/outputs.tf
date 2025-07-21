output "region_id" {
  description = "The URL of the App Runner service."
  value       = module.current_account.region_id
}

output "user_front_apprunner_service_url" {
  description = "The URL of the App Runner service."
  value       = module.user_front_apprunner.apprunner_service_url
}

output "user_front_created_ecr_name" {
  description = "The name of the ECR repository created by the module."
  value       = module.user_front_apprunner.ecr_name
}

output "user_front_apprunner_arn" {
  description = "The arn of the App Runner service."
  value       = module.user_front_apprunner.apprunner_arn
}

output "user_front_github_actions_role" {
  description = "ARN of the IAM role for GitHub Actions to deploy to App Runner."
  value       = aws_iam_role.github_actions_role_user_front.arn
}

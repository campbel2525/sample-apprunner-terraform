# ---------------------------------------------
# 共通
# ---------------------------------------------
output "region_id" {
  description = "The URL of the App Runner service."
  value       = module.current_account.region_id
}

# ---------------------------------------------
# rds
# ---------------------------------------------
output "rds_arn" {
  value = module.rds.arn
}

output "rds_dns_address" {
  value = module.rds.dns_address
}

# ---------------------------------------------
# user_front
# ---------------------------------------------
# output "user_front_apprunner_arn" {
#   description = "The arn of the App Runner service."
#   value       = module.user_front_apprunner.arn
# }

# output "user_front_apprunner_service_url" {
#   description = "The URL of the App Runner service."
#   value       = module.user_front_apprunner.service_url
# }

output "user_front_created_ecr_name" {
  description = "The name of the ECR repository created by the module."
  value       = module.user_front_ecr.name
}

output "user_front_github_actions_role" {
  description = "ARN of the IAM role for GitHub Actions to deploy to App Runner."
  value       = module.user_front_github_actions_role.arn
}

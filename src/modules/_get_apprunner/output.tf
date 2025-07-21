output "id" {
  description = "The ID of the App Runner service."
  value       = data.aws_apprunner_service.service.service_id
}

output "arn" {
  description = "The ARN of the App Runner service."
  value       = data.aws_apprunner_service.service.arn
}

output "service_url" {
  description = "The URL of the App Runner service."
  value       = data.aws_apprunner_service.service.service_url
}

# output "status" {
#   description = "The current status of the App Runner service."
#   value       = data.aws_apprunner_service.service.status
# }

# 必要に応じて他の属性も追加できます
# (例: health_check_configuration, instance_configurationなど)

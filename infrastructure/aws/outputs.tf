output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "current_region" {
  value = var.aws_region
}

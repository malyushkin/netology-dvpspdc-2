output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "current_aws_region" {
  value = data.aws_region.current.name
}

output "instance_private_ip" {
  value = aws_instance.web.private_ip
}

output "instance_subnet_id" {
  value = aws_instance.web.subnet_id
}
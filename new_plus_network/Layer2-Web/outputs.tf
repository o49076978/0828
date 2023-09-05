#-----------------------------
output "my_securitygroup_id" {
  description = "Security Group ID for my Servers"
  value       = aws_security_group.general.id
}

/*
output "my_securitygroup_all_detais" {
  description = "All the details of my Secueity Group for my Servers"
  value       = aws_security_group.general
}
*/

output "web_private_ip" {
  value = aws_instance.my_server_web.private_ip
}

output "app_private_ip" {
  value = aws_instance.my_server_app.private_ip
}

output "db_private_ip" {
  value = aws_instance.my_server_db.private_ip
}

output "instances_ids" {
  value = [
    aws_instance.my_server_web.id,
    aws_instance.my_server_app.id,
    aws_instance.my_server_db.id
  ]
}

#-------
output "rds_address" {
  value = aws_db_instance.prod.address
}

output "rds_port" {
  value = aws_db_instance.prod.port
}

output "rds_username" {
  value = aws_db_instance.prod.username
}

output "rds_password" {
  value     = data.aws_ssm_parameter.rds_password.value
  sensitive = true
}

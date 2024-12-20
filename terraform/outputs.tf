output "public_ip" {
  description = "Public IP address of the Apache server"
  value       = aws_instance.apache_server.public_ip
}

output "public_dns" {
  description = "Public DNS name of the Apache server"
  value       = aws_instance.apache_server.public_dns
}


output "rds_endpoint" {
  description = "Endpoint of the RDS instance—internal to VPC only (informative)"
  value       = var.enable_rds && length(aws_db_instance.mysql_db) > 0 ? aws_db_instance.mysql_db[0].address : null
}

output "rds_port" {
  description = "Port of the RDS instance—internal to VPC only (informative)"
  value       = var.enable_rds && length(aws_db_instance.mysql_db) > 0 ? aws_db_instance.mysql_db[0].port : null
}

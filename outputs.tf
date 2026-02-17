output "ips_servidores_docker" {
  description = "Las IPs de tus nuevos servidores con Docker"
  value       = aws_instance.servidores_docker[*].public_ip
}

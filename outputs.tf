output "ips_servidores_vpc_privada" {
  description = "Las IPs de tus servidores dentro de tu propia red privada"
  value       = aws_instance.servidores_docker_pro[*].public_ip
}

output "id_de_tu_vpc" {
  description = "El ID de tu red exclusiva"
  value       = aws_vpc.red_principal.id
}

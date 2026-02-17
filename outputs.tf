output "ips_publicas" {
  description = "Las IPs de tus servidores"
  value       = aws_instance.servidores_web[*].public_ip
}

output "url_del_balanceador" {
  description = "LA URL ÚNICA DE TU APP (El punto de entrada)"
  value       = "http://${aws_lb.mi_alb.dns_name}"
}

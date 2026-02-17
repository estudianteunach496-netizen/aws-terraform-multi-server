# Infraestructura como Código (IaC) con Terraform, AWS y Docker 🐳🚀

Este proyecto automatiza el despliegue de una arquitectura web moderna y escalable en **Amazon Web Services (AWS)** utilizando **Terraform** y contenedores **Docker**.

## 🏗️ Arquitectura y Tecnologías
- **Infraestructura**: Despliegue automatizado de instancias **EC2** con Amazon Linux 2.
- **Contenedores (Docker)**: Configuración automática del motor Docker en el arranque de las instancias.
- **Orquestación Básica**: Despliegue de contenedores **Nginx** personalizados mediante scripts de `user_data`.
- **Seguridad**: Reglas de Firewall (Security Groups) optimizadas para tráfico web.
- **Escalabilidad**: Implementación de lógica de múltiples nodos usando la propiedad `count`.

## 🧠 Conocimientos Aplicados
Este repositorio demuestra habilidades avanzadas en:
- **Terraform**: Uso de proveedores, recursos, data sources, variables secretas (`tfvars`) y gestión de estado.
- **Cloud Computing (AWS)**: Manejo de cómputo (EC2), redes (VPC, Subnets) y seguridad.
- **DevOps**: Automatización de la instalación y ejecución de contenedores Docker en entornos de nube.
- **Git/GitHub**: Flujo de trabajo profesional y protección de secretos mediante `.gitignore`.

## 🚀 Cómo ejecutarlo
1. Clona este repositorio.
2. Crea tu archivo `terraform.tfvars`:
   ```hcl
   aws_access_key = "TU_ACCESS_KEY"
   aws_secret_key = "TU_SECRET_KEY"
   ```
3. Inicia y aplica:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```

## 🔒 Control de Costos y Seguridad
Este proyecto sigue las mejores prácticas de seguridad, ocultando credenciales sensibles y permitiendo la destrucción total de los recursos con un solo comando (`terraform destroy`), garantizando que la cuenta de AWS se mantenga dentro del **Free Tier**.

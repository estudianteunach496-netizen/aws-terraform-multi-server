# Infraestructura como Código (IaC) con Terraform y AWS 🚀

Este proyecto automatiza el despliegue de una arquitectura web escalable en **Amazon Web Services (AWS)** utilizando **Terraform**.

## 🏗️ Arquitectura
- **Servidores Web**: 2 instancias EC2 (Amazon Linux 2) configuradas automáticamente con Apache.
- **Seguridad**: Grupo de seguridad (Firewall) configurado para permitir tráfico HTTP.
- **Escalabilidad**: Uso de la propiedad `count` para despliegues múltiples.
- **Automatización**: Uso de `user_data` para configuración de software en el arranque.

## 🛠️ Requisitos
1. Cuenta de AWS con el Free Tier activo.
2. Terraform v1.14.5+ instalado.
3. AWS CLI o llaves de acceso (IAM User).

## 🚀 Cómo usar este proyecto
1. Clonar el repositorio.
2. Crear un archivo `terraform.tfvars` con tus credenciales:
   ```hcl
   aws_access_key = "TU_ACCESS_KEY"
   aws_secret_key = "TU_SECRET_KEY"
   ```
3. Ejecutar:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```

## 🔒 Seguridad
Este proyecto utiliza un archivo `.gitignore` para asegurar que las llaves de AWS (`terraform.tfvars`) y el estado de Terraform nunca se suban al repositorio público.

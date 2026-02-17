# Infraestructura de Nivel Senior con Terraform, AWS y Docker 🐳🔝

Este proyecto despliega una infraestructura de nube completa, utilizando la metodología de **Infraestructura como Código (IaC)** para crear redes personalizadas y contenedores dockerizados.

## 🏗️ Ingeniería de Redes (VPC)
A diferencia de proyectos básicos, este repositorio construye una arquitectura de red aislada y segura:
- **VPC Custom**: Una red virtual privada (10.0.0.0/16) exclusiva para la aplicación.
- **Networking Pro**: Implementación de **Subnets públicas**, **Internet Gateway** propio y **Tablas de Rutas** personalizadas.
- **Docker Orchestration**: Instalación y ejecución automatizada de contenedores **Nginx** en cada servidor.
- **Seguridad Dinámica**: Grupos de seguridad exclusivos atados a la VPC personalizada.

## 🚀 Cómo ejecutar
1. Clona el proyecto.
2. Agrega tus llaves en `terraform.tfvars`.
3. Ejecuta:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```

## 🧠 Valor Agregado para el Negocio
- **Aislamiento Total**: Seguridad mejorada al no usar configuraciones por defecto de AWS.
- **Escalabilidad**: Red preparada para crecer horizontalmente.
- **Automatización**: Despliegue de 0 a 100 en menos de 2 minutos.

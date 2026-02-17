provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# 1. Obtener la VPC por defecto
data "aws_vpc" "default" {
  default = true
}

# 2. Servidores con DOCKER
resource "aws_instance" "servidores_docker" {
  count         = 2
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t3.micro"

  user_data = <<-EOF
              #!/bin/bash
              # 1. Actualizar e instalar Docker
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              systemctl enable docker

              # 2. Correr un contenedor de Nginx (Web moderna)
              docker run -d -p 80:80 --name mi-web nginx
              
              # 3. Personalizar la página dentro del contenedor
              docker exec mi-web sh -c "echo '<h1>Hola desde Docker en el Servidor ${count.index + 1}</h1>' > /usr/share/nginx/html/index.html"
              EOF

  tags = {
    Name = "Servidor-Docker-${count.index + 1}"
  }
  
  vpc_security_group_ids = [aws_security_group.permitir_web.id]
}

# 3. Grupo de Seguridad (Sigue igual, puerto 80 abierto)
resource "aws_security_group" "permitir_web" {
  name_prefix = "web-sg-docker-"
  description = "Permite trafico HTTP para Docker"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

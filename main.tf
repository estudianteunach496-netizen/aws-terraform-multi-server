provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# --- RED PROFESIONAL (VPC) ---

# 1. Crear la VPC (Tu propia red privada)
resource "aws_vpc" "red_principal" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPC-Profesional"
  }
}

# 2. Crear una Subred Pública (Donde vivirán tus servidores)
resource "aws_subnet" "subnet_publica" {
  vpc_id                  = aws_vpc.red_principal.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true # Para que los servidores tengan IP pública

  tags = {
    Name = "Subnet-Publica-Pro"
  }
}

# 3. Internet Gateway (La puerta de salida a Internet)
resource "aws_internet_gateway" "mi_puerta" {
  vpc_id = aws_vpc.red_principal.id

  tags = {
    Name = "Salida-Internet"
  }
}

# 4. Tabla de Rutas (El mapa para navegar)
resource "aws_route_table" "mi_mapa" {
  vpc_id = aws_vpc.red_principal.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mi_puerta.id
  }

  tags = {
    Name = "Tabla-Rutas-Principal"
  }
}

# 5. Unir la Subred con la Tabla de Rutas
resource "aws_route_table_association" "union" {
  subnet_id      = aws_subnet.subnet_publica.id
  route_table_id = aws_route_table.mi_mapa.id
}

# --- INFRAESTRUCTURA (DOCKER) ---

# 6. Servidores con Docker dentro de tu nueva red
resource "aws_instance" "servidores_docker_pro" {
  count         = 2
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t3.micro"
  
  subnet_id     = aws_subnet.subnet_publica.id # <--- AQUI LA MAGIA: Dentro de tu VPC

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              systemctl enable docker
              docker run -d -p 80:80 --name mi-web nginx
              docker exec mi-web sh -c "echo '<h1>Hola desde VPC Privada en el Servidor ${count.index + 1}</h1>' > /usr/share/nginx/html/index.html"
              EOF

  tags = {
    Name = "Server-VPC-${count.index + 1}"
  }
  
  vpc_security_group_ids = [aws_security_group.permitir_web_pro.id]
}

# 7. Grupo de Seguridad (Firewall) dentro de tu VPC
resource "aws_security_group" "permitir_web_pro" {
  name        = "web-sg-vpc"
  description = "Seguridad para VPC"
  vpc_id      = aws_vpc.red_principal.id # <--- Atado a tu red privada

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
}

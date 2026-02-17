
provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# 1. Obtener la VPC por defecto
data "aws_vpc" "default" {
  default = true
}

# 2. Obtener Subnets en diferentes AZs de forma automática
data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 3. Servidores (EC2)
resource "aws_instance" "servidores_web" {
  count         = 2
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t3.micro"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Servidor numero ${count.index + 1}</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Servidor-Web-${count.index + 1}"
  }
  
  vpc_security_group_ids = [aws_security_group.permitir_web.id]
}

# 4. Grupo de Seguridad (Firewall)
resource "aws_security_group" "permitir_web" {
  name_prefix = "web-sg-alb-" # Usamos prefijo para evitar choques
  description = "Permite trafico HTTP"

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

# 5. EL BALANCEADOR (ALB) - Con corrección de zonas
resource "aws_lb" "mi_alb" {
  name               = "web-alb-2026"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.permitir_web.id]
  
  # Tomamos todas las subredes disponibles para asegurar diversidad de AZs
  subnets            = data.aws_subnets.all.ids

  enable_deletion_protection = false
}

# 6. Grupo de Destino (Target Group)
resource "aws_lb_target_group" "mi_tg" {
  name     = "web-tg-alb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path = "/"
    port = "80"
  }
}

# 7. Oyente (Listener)
resource "aws_lb_listener" "mi_listener" {
  load_balancer_arn = aws_lb.mi_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mi_tg.arn
  }
}

# 8. Unir servidores
resource "aws_lb_target_group_attachment" "test" {
  count            = 2
  target_group_arn = aws_lb_target_group.mi_tg.arn
  target_id        = aws_instance.servidores_web[count.index].id
  port             = 80
}

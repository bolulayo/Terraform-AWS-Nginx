provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

resource "aws_instance" "nginx_server" {
  ami           = "ami-08c40ec9ead489470" # Ubuntu 20.04 AMI ID for us-east-1 (replace if in a different region)
  instance_type = "t2.micro"
  key_name      = var.key_pair_name

  security_groups = [aws_security_group.nginx_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
  EOF

  tags = {
    Name = "nginx-server"
  }
}

resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

output "public_ip" {
  value = aws_instance.nginx_server.public_ip
  description = "Public IP of the Nginx server"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

# ─── TLS Private Key Generation ───────────────────────────────
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# ─── AWS Key Pair (uses generated public key) ─────────────────
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.ec2_key.public_key_openssh

  tags = {
    Name        = var.key_pair_name
    Environment = var.environment
  }
}

# ─── Save Private Key Locally as .pem file ────────────────────
resource "local_file" "private_key_pem" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.module}/${var.key_pair_name}.pem"
  file_permission = "0400"   # Read-only for owner (SSH requirement)
}

# ─── Security Group ───────────────────────────────────────────
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # Restrict to your IP in production
  }

  ingress {
    description = "HTTP"
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

  tags = {
    Name = "ec2-security-group"
  }
}

# ─── Data Sources: Latest AMIs ────────────────────────────────

# Ubuntu 24.04 LTS (latest)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]   # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Amazon Linux 2023 (latest)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ─── EC2 Instance: Ubuntu ─────────────────────────────────────
resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name        = "ubuntu-instance"
    OS          = "Ubuntu"
    Environment = var.environment
  }
}

# ─── EC2 Instance: Amazon Linux ───────────────────────────────
resource "aws_instance" "amazon_linux" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name        = "amazon-linux-instance"
    OS          = "Amazon Linux"
    Environment = var.environment
  }
}
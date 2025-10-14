# =========================
# VPC and Subnets
# =========================

# Default VPC
data "aws_vpc" "default" {
  default = true
}

# Default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# =========================
# Security Group for SSH and HTTP
# =========================
resource "aws_security_group" "default_sg" {
  name        = "devops_project_sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]  # Replace with your IP /32
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

# =========================
# EC2 Instances
# =========================

# Jenkins Master
resource "aws_instance" "jenkins_master" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_key.key_name
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.default_sg.id]

  tags = {
    Name        = "Jenkins-Master"
    Environment = "Master"
  }
}

# Jenkins Slave
resource "aws_instance" "jenkins_slave" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_key.key_name
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.default_sg.id]

  tags = {
    Name        = "Jenkins-Slave"
    Environment = "Slave"
  }
}

# Dev Server
resource "aws_instance" "dev_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_key.key_name
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.default_sg.id]

  tags = {
    Name        = "Dev-Server"
    Environment = "Dev"
  }
}

# Stage Server
resource "aws_instance" "stage_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_key.key_name
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.default_sg.id]

  tags = {
    Name        = "Stage-Server"
    Environment = "Stage"
  }
}

# Prod Server
resource "aws_instance" "prod_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_key.key_name
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.default_sg.id]

  tags = {
    Name        = "Prod-Server"
    Environment = "Prod"
  }
}

# =========================
# Outputs
# =========================
output "jenkins_master_ip" {
  value = aws_instance.jenkins_master.public_ip
}

output "jenkins_slave_ip" {
  value = aws_instance.jenkins_slave.public_ip
}

output "dev_server_ip" {
  value = aws_instance.dev_server.public_ip
}

output "stage_server_ip" {
  value = aws_instance.stage_server.public_ip
}

output "prod_server_ip" {
  value = aws_instance.prod_server.public_ip
}

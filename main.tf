provider "aws" {
  region  = "ap-south-1"
  profile = "IAMAdmin"
}

data "external" "my_ip" {
  program = ["bash", "${path.module}/get_ip.sh"]
}

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "example_key" {
  key_name   = "Web-Devops-new"
  public_key = tls_private_key.my_key.public_key_openssh
  tags = {
    Name = "Web-Devops-new"
  }
}

resource "local_file" "private_key_file" {
  filename = "${path.module}/Web-Devops-new.pem"
  content  = tls_private_key.my_key.private_key_pem
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Web-devops-new"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "Web-devops-new"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Web-devops-new"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Web-devops-new"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.external.my_ip.result.ip}/32"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh(Web-devops-new)"
  }
}

resource "aws_instance" "v1" {
  ami                    = "ami-04a37924ffe27da53"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  key_name               = aws_key_pair.example_key.key_name

  root_block_device {
    volume_size  = 8
    volume_type  = "gp3"
    encrypted    = true
  }

  tags = {
    Name = "Web-App(Devops)"
  }
}

output "public_ip" {
  value = aws_instance.v1.public_ip
}

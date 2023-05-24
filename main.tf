terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67"
    }

    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "aws" {
    region = var.region
}

data "aws_ami" "ubuntu" {
  
  most_recent      = true
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "tls_private_key" "mykey" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "aws_key" {
    key_name   = "aws_key.pem"
    public_key = tls_private_key.mykey.public_key_openssh
}

resource "aws_instance" "webserver" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = var.my_instance_type
    key_name               = aws_key_pair.aws_key.key_name
    vpc_security_group_ids = [aws_security_group.sec_group.id]
    user_data              = file("install_lib.sh")
    user_data_replace_on_change = true 
}

resource "aws_security_group" "sec_group" {
    ingress{
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
    }

        ingress{
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 80
        to_port     = 80
        description = "Http ports"
        protocol    = "tcp"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
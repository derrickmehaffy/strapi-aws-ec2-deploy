terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.14.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Configure Cloudflare
provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

resource "cloudflare_record" "strapi_api_a" {
  count   = var.cloudflare_enabled ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = var.strapi_srv_domain
  value   = aws_instance.strapi_server.public_ip
  type    = "A"
  ttl     = "1"
  proxied = false
}

# AWS SSH Key
resource "aws_key_pair" "strapi_ssh_key" {
  key_name   = "strapi-ssh-key"
  public_key = var.ssh_key
}

# AWS VPC Instance
resource "aws_vpc" "strapi" {
  cidr_block           = var.strapi_vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.strapi_vpc_name
  }
}

resource "aws_subnet" "strapi_main" {
  vpc_id                  = aws_vpc.strapi.id
  cidr_block              = var.strapi_subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = var.strapi_subnet_name
  }
}

resource "aws_internet_gateway" "strapi_gw" {
  vpc_id = aws_vpc.strapi.id

  tags = {
    Name = var.strapi_gateway_name
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_vpc.strapi.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.strapi_gw.id
}

# AWS Security Group Rules
resource "aws_security_group" "strapi_app" {
  name        = "strapi_app_sg"
  description = "Strapi Application firewall rules"
  vpc_id      = aws_vpc.strapi.id

  ingress {
    description = "inbound ssh"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "inbound strapi debug"
    from_port   = 1337
    protocol    = "tcp"
    to_port     = 1337
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "inbound http"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "inbound https"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "strapi_db" {
  name        = "strapi_db_sg"
  description = "Strapi Database firewall rules"
  vpc_id      = aws_vpc.strapi.id

  ingress {
    description = "inbound ssh"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "inbound mariadb"
    from_port   = 3306
    protocol    = "tcp"
    to_port     = 3306
    cidr_blocks = [aws_vpc.strapi.cidr_block]
  }

  egress {
    description = "outbound all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# AWS Ubuntu AMI Lookup
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# AWS Strapi Server Instance
resource "aws_instance" "strapi_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.strapi_plan
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.strapi_main.id
  vpc_security_group_ids      = [aws_security_group.strapi_app.id]
  key_name                    = aws_key_pair.strapi_ssh_key.key_name
  availability_zone           = var.availability_zone
  tags = {
    Name = var.strapi_label
  }
  root_block_device {
    volume_size           = 32
    delete_on_termination = true
  }
}

# AWS Strapi Database Instance
resource "aws_instance" "strapi_database" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.database_plan
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.strapi_main.id
  vpc_security_group_ids      = [aws_security_group.strapi_db.id]
  key_name                    = aws_key_pair.strapi_ssh_key.key_name
  availability_zone           = var.availability_zone
  tags = {
    Name = var.database_label
  }
  root_block_device {
    volume_size           = 32
    delete_on_termination = true
  }
}

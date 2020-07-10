# INITIALIZE AWS PROVIDER
provider "aws" {
  region = "us-west-2"
}

# CREATE AWS INSTANCE
resource "aws_instance" "aws_vm" {
  ami           = data.aws_ami.most_recent_ami.id
  instance_type = "t2.micro"
  user_data     = file("scripts/cloud-init.cfg")
  key_name      = "rpeteuil"

  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name    = "rpeteuil-server-dev"
    TTL     = "4"
    owner   = "rpeteuil"
    project = "demo"
  }
}

# FIND MOST RECENT IMAGE
data "aws_ami" "most_recent_ami" {
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  most_recent = true

  owners = ["099720109477"]
}

# CREATE NETWORK SECURITY GROUP ALLOWING SSH
resource "aws_security_group" "ssh" {
  name        = "rpeteuil-server-dev-ssh"
  description = "rpeteuil-server SSH"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rpeteuil-server-dev-ssh"
  }
}

# DISPLAY PUBLIC IP ADDRESS
output "instance_ip_address" {
  description = "Instance IP Address"
  value       = aws_instance.aws_vm.public_ip
}

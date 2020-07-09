#
# INITIALIZE AWS PROVIDER
provider "aws" {
  region = "us-west-2"
}

# CREATE AWS INSTANCE (VM)
resource "aws_instance" "aws_vm" {
  ami           = "${data.aws_ami.most_recent_ami.id}"
  instance_type = "t2.micro"
  user_data     = "${file("../scripts/cloud-init.cfg")}"
  key_name      = "rpeteuil"

  vpc_security_group_ids = ["${aws_security_group.ssh.id}"]

  tags {
    Name = "test-server-dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# FIND MOST RECENT IMAGE SPECIFIED
data "aws_ami" "most_recent_ami" {
  owners = ["099720109477"]

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

# FIND EXISTING PUBLIC IP
data "external" "get_local_public_ip" {
  program = ["sh", "../scripts/get_local_pub_ip.sh"]
}

# CREATE NETWORK SECURITY GROUP ALLOWING PUBLIC SSH
resource "aws_security_group" "ssh" {
  name        = "test-server-dev-ssh"
  description = "test-server SSH"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["${data.external.get_local_public_ip.result.ip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "rpeteuil-server-dev-ssh"
  }
}

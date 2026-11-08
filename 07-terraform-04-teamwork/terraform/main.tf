# AWS Provider
provider "aws" {
  region = "eu-west-3"
}

# AMI Data
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

  owners = ["099720109477"]
}

# Instance Resources
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  count         = 1

  cpu_core_count       = 1
  cpu_threads_per_core = 1
  monitoring           = true

  tags = {
    org  = "netology"
    name = "ubuntu_instance"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# EC2 module
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t1.micro"
  count         = 1 
}

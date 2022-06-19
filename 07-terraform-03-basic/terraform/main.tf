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
  instance_type = local.web_instance_type_map[terraform.workspace]
  count         = local.web_count_map[terraform.workspace]

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

resource "aws_instance" "web_with_for_each_expr" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type_map[terraform.workspace]

  for_each = local.web_vm_map[terraform.workspace]

  monitoring = true

  tags = {
    org  = "netology"
    name = "ubuntu_instance"
  }
}

# S3 Bucket resource
resource "aws_s3_bucket" "terraform_state" {
  bucket = "romanmaliushkin-netology-terraform-state"

  versioning {
    enabled = true
  }
}

# DynamoDB Table resource
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
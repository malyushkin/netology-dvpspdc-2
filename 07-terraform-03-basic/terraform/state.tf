terraform {
  backend "s3" {
    bucket         = "romanmaliushkin-netology-terraform-state"
    key            = "state/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
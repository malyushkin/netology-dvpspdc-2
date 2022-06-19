locals {
  web_instance_type_map = {
    stage = "t3.micro"
    prod  = "t3.large"
  }

  web_count_map = {
    stage = 1
    prod  = 2
  }

  web_vm_map = {
    stage = { count = 1 }
    prod  = { count = 2 }
  }
}
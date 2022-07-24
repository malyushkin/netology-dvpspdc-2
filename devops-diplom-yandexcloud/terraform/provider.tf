terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.75.0"
    }
  }
}

provider "yandex" {
  token     = var.YANDEX_TOKEN
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone      = "ru-central1-a"
}
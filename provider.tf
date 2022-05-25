terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.62.0"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  token     = var.token
  zone      = "ru-central1-a"
}
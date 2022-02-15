provider "yandex" {
  token     = var.token
  folder_id = var.folder
  zone      = var.zone
}

locals {
  file_destination = "cat.jpg"
  file_source = "terraform.jpg"
  bucket_name = "netology-15-2"
}

module "sa_storage" {
  source = "../modules/sa"

  name   = "sa-storage"
  role   = "editor"
  folder = var.folder
}

module "kms" {
  source = "../modules/kms"

  name   = "bucket"
}

module "bucket" {
  source = "../modules/bucket"

  folder = var.folder
  name   = local.bucket_name
  key    = module.sa_storage.key
  file_source = local.file_source
  file_destination = local.file_destination
  sse    = {"key": module.kms.key.id}
}

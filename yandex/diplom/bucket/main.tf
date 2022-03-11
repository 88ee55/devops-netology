provider "yandex" {
  service_account_key_file = "../key.json"
  folder_id                = var.folder-id
  zone                     = var.zone
}

module "sa_terraform_states" {
  source = "../../modules/sa"

  name   = "sa-terraform-states"
  role   = "editor"
  folder = var.folder-id
}

module "kms" {
  source = "../../modules/kms"

  name = "terraform-states"
}

module "bucket" {
  source = "../../modules/bucket"

  name = var.bucket
  key  = module.sa_terraform_states.key
  sse  = { "key" : module.kms.key.id }
}

resource "local_file" "default" {
  content  = templatefile("version.tftpl", { key = module.sa_terraform_states.key, bucket = var.bucket })
  filename = "../project/version.tf"
}
provider "yandex" {
  token     = var.token
  folder_id = var.folder
  zone      = var.zone
}

locals {
  subnet_private = {
    ru-central1-a = "192.168.10.0/24",
    ru-central1-b = "192.168.20.0/24",
    ru-central1-c = "192.168.30.0/24",
  }
  subnet_public = {
    ru-central1-a = "192.168.110.0/24",
    ru-central1-b = "192.168.120.0/24",
    ru-central1-c = "192.168.130.0/24",
  }
  resource = {
    vm_type   = "b1.medium"
    disk_type = "network-ssd"
    disk_size = 20
  }
  backup_time = {
    hour   = 23
    minute = 59
  }
  // вынести в var, для тестов в открытом виде
  credentials = {
    user = "user"
    pass = "passpass"
  }
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

module "cloudinit" {
  source = "../modules/cloudinit"

  template = tls_private_key.key.private_key_pem
}

resource "yandex_vpc_network" "netology" {
  name = "netology"
}

# task 1.1
module "subnet_private" {
  source   = "../modules/subnet"
  for_each = local.subnet_private

  name    = each.key
  cidr    = ["${each.value}"]
  network = yandex_vpc_network.netology.id
  zone    = each.key
  prefix  = "private"
}

module "mysql" {
  source = "../modules/mdb_mysql"

  name        = "netology"
  network     = yandex_vpc_network.netology.id
  host        = module.subnet_private
  resource    = local.resource
  db_name     = "netology_db"
  backup_time = local.backup_time
  protect     = var.protect
  credentials = local.credentials

}

# task 1.2
module "sa_service" {
  source = "../modules/sa"

  name   = "sa-service"
  role   = "editor"
  folder = var.folder
}

module "sa_node" {
  source = "../modules/sa"

  name   = "sa-node"
  role   = "container-registry.images.puller"
  folder = var.folder
}

module "kms" {
  source = "../modules/kms"

  name = "k8s"
}

module "subnet_public" {
  source   = "../modules/subnet"
  for_each = local.subnet_public

  name    = each.key
  cidr    = ["${each.value}"]
  network = yandex_vpc_network.netology.id
  zone    = each.key
  prefix  = "public"
}

module "k8s" {
  source = "../modules/k8s"

  name             = "netology"
  network          = yandex_vpc_network.netology.id
  instance_service = module.subnet_public
  instance_node    = module.subnet_private
  sa_service       = module.sa_service.sa
  sa_node          = module.sa_node.sa
  kms              = module.kms
  depends_on = [
    module.sa_service.sa,
    module.sa_node.sa
  ]
}
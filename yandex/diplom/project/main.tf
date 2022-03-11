provider "yandex" {
  service_account_key_file = "../key.json"
  folder_id                = var.folder-id
  zone                     = var.zone
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
  k8s_node = {
    prod = {
      location = "ru-central1-b"
      resources = {
        memory        = 2
        cores         = 2
        core_fraction = 20
      }
      preemptible = false
      boot_disk = {
        type = "network-ssd"
        size = 30
      }
      scale_policy = {
        auto_scale = {
          initial = 3
          min     = 3
          max     = 6
        }
      }
    }
  }
}

resource "yandex_vpc_network" "netology" {
  name = "netology-${terraform.workspace}"
}

module "subnet_public" {
  source   = "../../modules/subnet"
  for_each = local.subnet_public

  name    = each.key
  cidr    = ["${each.value}"]
  network = yandex_vpc_network.netology.id
  zone    = each.key
  prefix  = "public"
}

module "subnet_private" {
  source   = "../../modules/subnet"
  for_each = local.subnet_private

  name    = each.key
  cidr    = ["${each.value}"]
  network = yandex_vpc_network.netology.id
  zone    = each.key
  prefix  = "private"
}

module "sa_service" {
  source = "../../modules/sa"

  name   = "sa-k8s-service-${terraform.workspace}"
  role   = "editor"
  folder = var.folder-id
}

module "sa_node" {
  source = "../../modules/sa"

  name   = "sa-k8s-node-${terraform.workspace}"
  role   = "container-registry.images.puller"
  folder = var.folder-id
}

module "kms" {
  source = "../../modules/kms"

  name = "k8s-${terraform.workspace}"
}

module "k8s_cluster" {
  source = "../../modules/k8s_cluster"

  name           = "netology-${terraform.workspace}"
  network        = yandex_vpc_network.netology.id
  subnet_service = module.subnet_public
  sa_service     = module.sa_service.id
  sa_node        = module.sa_node.id
  kms            = module.kms
  depends_on = [
    module.sa_service,
    module.sa_node
  ]
}

module "k8s_node" {
  source = "../../modules/k8s_node"

  name        = "node"
  cluster_id  = module.k8s_cluster.id
  subnet_node = module.subnet_private
  k8s_node    = local.k8s_node["${terraform.workspace}"]
}
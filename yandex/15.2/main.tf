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


#task 1.1
module "sa_storage" {
  source = "../modules/sa"

  name   = "sa-storage"
  role   = "storage.editor"
  folder = var.folder
}

module "bucket" {
  source = "../modules/bucket"

  folder = var.folder
  name   = local.bucket_name
  key    = module.sa_storage.key
  file_source = local.file_source
  file_destination = local.file_destination
}

# task 1.2
resource "yandex_vpc_network" "netology" {
  name = "netology"
}

module "sa_ig" {
  source = "../modules/sa"

  name   = "sa-ig"
  role   = "editor"
  folder = var.folder
}

module "subnet" {
  source = "../modules/subnet"

  name        = "private"
  cidr        = ["192.168.20.0/24"]
  network     = yandex_vpc_network.netology.id
}

module "cloudinit" {
  source   = "../modules/cloudinit"

  template = "<html><img src='https://storage.yandexcloud.net/${local.bucket_name}/${local.file_destination}'></html>"
}

module "instance_group" {
  source   = "../modules/instance_group"

  folder   = var.folder
  name     = "lamp"
  image    = "fd827b91d99psvq5fjit"
  sa       = module.sa_ig.sa
  subnets  = [module.subnet.subnet_id]
  sshkey   = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  userdata = module.cloudinit.rendered
  depends_on = [
    module.sa_ig,
  ]
}

#task 1.3
module "lb" {
  source = "../modules/nlb"

  instances   = module.instance_group.instances
  depends_on = [
    module.instance_group,
  ]
}

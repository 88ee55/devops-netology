provider "yandex" {
  token     = var.token
  folder_id = var.folder
  zone      = var.zone
}


resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

module "cloudinit" {
  source = "../modules/cloudinit"

  template = tls_private_key.key.private_key_pem
}


#task 1.1
resource "yandex_vpc_network" "netology" {
  name = "netology"
}


#task 1.2
module "subnet_public" {
  source = "../modules/subnet"

  name    = "public"
  cidr    = ["192.168.10.0/24"]
  network = yandex_vpc_network.netology.id
}

module "public_instance" {
  source = "../modules/instance"

  name     = "public-vm"
  image    = "fd80mrhj8fl2oe87o4e1"
  subnet   = module.subnet_public.subnet_id
  ip       = "192.168.10.254"
  nat      = true
  sshkey   = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  userdata = module.cloudinit.rendered
}


#task 1.3
module "route_table" {
  source = "../modules/route_table"

  next_hop_address = "192.168.10.254"
  network_id       = yandex_vpc_network.netology.id
}

module "subnet_private" {
  source = "../modules/subnet"

  name        = "private"
  cidr        = ["192.168.20.0/24"]
  network     = yandex_vpc_network.netology.id
  route_table = module.route_table.route_table_id
}

module "private_instance" {
  source = "../modules/instance"

  name   = "private-vm"
  image  = "fd827b91d99psvq5fjit"
  subnet = module.subnet_private.subnet_id
  sshkey = "ubuntu:${tls_private_key.key.public_key_openssh}"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.name
  v4_cidr_blocks = var.cidr
  network_id     = var.network
  route_table_id = var.route_table != "" ? var.route_table : null
}
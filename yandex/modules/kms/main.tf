resource "yandex_kms_symmetric_key" "default" {
  name              = var.name
  default_algorithm = "AES_128"
}
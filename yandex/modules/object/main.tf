resource "yandex_storage_object" "default" {
  access_key = var.key.access_key
  secret_key = var.key.secret_key
  bucket     = var.name
  key        = var.file_destination
  source     = var.file_source
  acl        = var.acl
  depends_on = [
    yandex_storage_bucket.default,
  ]
}
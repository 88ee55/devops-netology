resource "yandex_storage_bucket" "default" {
  access_key = var.key.access_key
  secret_key = var.key.secret_key
  bucket     = var.name
  acl        = var.acl

  dynamic "server_side_encryption_configuration" {
    for_each = var.sse
    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = server_side_encryption_configuration.value
          sse_algorithm     = "aws:kms"
        }
      }
    }
  }
}
output "key" {
  value = yandex_iam_service_account_static_access_key.default
}

output "id" {
  value = yandex_iam_service_account.default.id
}
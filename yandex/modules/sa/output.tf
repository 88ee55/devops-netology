output "key" {
    value =  yandex_iam_service_account_static_access_key.default
}

output "sa" {
    value =  yandex_iam_service_account.default.id
}
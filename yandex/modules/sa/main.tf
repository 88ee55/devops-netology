resource "yandex_iam_service_account" "default" {
  folder_id = var.folder
  name      = var.name
}

resource "yandex_resourcemanager_folder_iam_member" "default" {
  folder_id = var.folder
  role      = var.role
  member    = "serviceAccount:${yandex_iam_service_account.default.id}"
}

resource "yandex_iam_service_account_static_access_key" "default" {
  service_account_id = yandex_iam_service_account.default.id
  description        = "static access key"
}
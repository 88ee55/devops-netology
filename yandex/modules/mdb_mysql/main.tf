resource "yandex_mdb_mysql_cluster" "default" {
  name        = var.name
  environment = var.env
  network_id  = var.network
  version     = var.db_version

  resources {
    resource_preset_id = var.resource.vm_type
    disk_type_id       = var.resource.disk_type
    disk_size          = var.resource.disk_size
  }

  deletion_protection = var.protect

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = var.backup_time.hour
    minutes = var.backup_time.minute
  }

  database {
    name = var.db_name
  }

  user {
    name     = var.credentials.user
    password = var.credentials.pass
    permission {
      database_name = var.db_name
      roles         = ["ALL"]
    }
  }

  dynamic "host" {
    for_each = var.host
    content {
      zone      = host.key
      subnet_id = host.value.subnet_id
    }
  }

}

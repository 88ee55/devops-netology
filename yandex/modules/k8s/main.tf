resource "yandex_kubernetes_cluster" "regional" {
  name = var.name

  network_id = var.network

  master {
    regional {
      region = "ru-central1"

      dynamic "location" {
        for_each = var.instance_service
        content {
          zone      = location.key
          subnet_id = location.value.subnet_id
        }
      }
    }

    version   = var.k8s_version
    public_ip = true
  }

  service_account_id      = var.sa_service
  node_service_account_id = var.sa_node

  release_channel = var.k8s_release

  kms_provider {
    key_id = var.kms.key.id
  }
}

resource "yandex_kubernetes_node_group" "default" {
  cluster_id = yandex_kubernetes_cluster.regional.id
  name       = "node-${var.name}"
  version    = var.k8s_version

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      subnet_ids = [element([for id in var.instance_node : id.subnet_id], 0)]
    }

    resources {
      memory = 2
      cores  = 2
    }

    scheduling_policy {
      preemptible = true
    }

    boot_disk {
      type = "network-hdd"
      size = 30
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      initial = 3
      min     = 3
      max     = 6
    }
  }

  allocation_policy {
    location {
      zone = element([for k,v in var.instance_node: k], 0)
    }
  }
}
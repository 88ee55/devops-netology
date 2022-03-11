resource "yandex_compute_instance_group" "default" {
  name               = var.name
  folder_id          = var.folder
  service_account_id = var.sa

  instance_template {
    platform_id = "standard-v3"
    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    scheduling_policy {
      preemptible = true
    }

    boot_disk {
      initialize_params {
        image_id = var.image
        size     = 6
        type     = "network-ssd"
      }
    }
    network_interface {
      # network_id = "${yandex_vpc_network.my-inst-group-network.id}"
      subnet_ids = var.subnets
    }
    metadata = {
      ssh-keys  = var.sshkey
      user-data = var.userdata != "" ? var.userdata : null
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = var.zones
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }
}
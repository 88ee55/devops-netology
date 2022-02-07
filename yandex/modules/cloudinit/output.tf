output "private_key" {
    value = data.cloudinit_config.private_key.rendered
}
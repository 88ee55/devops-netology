data "cloudinit_config" "default" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cmd.sh"
    content_type = "text/x-shellscript"
    content      = templatefile("cloud.sh", { template = var.template })
  }
}

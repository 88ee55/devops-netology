data "cloudinit_config" "private_key" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cmd.sh"
    content_type = "text/x-shellscript"
    content      = templatefile("modules/cloudinit/cloud.sh",  {key = var.tls}) 
  }
}

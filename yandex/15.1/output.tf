output "public_ip" {
  value = module.public_instance.ext_ip
}

output "private_ip" {
  value = module.private_instance.int_ip
}
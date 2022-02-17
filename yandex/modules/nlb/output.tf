output "ip" {
  value = one(yandex_lb_network_load_balancer.default.listener.*.external_address_spec[0]).address
}
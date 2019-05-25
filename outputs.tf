output "droplet_ipv4_addr" {
  value = digitalocean_droplet.instance.*.ipv4_address
}

output "droplet_ipv4_addr_private" {
  value = digitalocean_droplet.instance.*.ipv4_address_private
}

output "droplet_ipv6_addr" {
  value = digitalocean_droplet.instance.*.ipv6_address
}

output "droplet_ipv6_addr_private" {
  value = digitalocean_droplet.instance.*.ipv6_address_private
}


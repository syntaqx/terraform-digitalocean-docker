output "urn" {
  value = digitalocean_droplet.instance.*.urn
}

output "ipv4_address" {
  value = digitalocean_droplet.instance.*.ipv4_address
}

output "ipv4_address_private" {
  value = digitalocean_droplet.instance.*.ipv4_address_private
}

output "ipv6_address" {
  value = digitalocean_droplet.instance.*.ipv6_address
}

output "ipv6_addr_private" {
  value = digitalocean_droplet.instance.*.ipv6_address_private
}

output "urns" {
  value = digitalocean_droplet.instance.*.urn
}

output "ipv4_addrs" {
  value = digitalocean_droplet.instance.*.ipv4_address
}

output "ipv4_addrs_private" {
  value = digitalocean_droplet.instance.*.ipv4_address_private
}

output "ipv6_addrs" {
  value = digitalocean_droplet.instance.*.ipv6_address
}

output "ipv6_addrs_private" {
  value = digitalocean_droplet.instance.*.ipv6_address_private
}

provider "digitalocean" {
}

resource "digitalocean_ssh_key" "default" {
  name       = "DigitalOcean Docker Example"
  public_key = file("~/.ssh/id_rsa.pub")
}

module "docker" {
  source = "../.." # "syntaqx/docker/digitalocean"

  prefix           = "example-"
  private_key_path = "~/.ssh/id_rsa"
  ssh_keys         = [digitalocean_ssh_key.default.id]
}

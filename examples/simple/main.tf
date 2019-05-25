provider "digitalocean" {
}

resource "digitalocean_ssh_key" "default" {
  name       = "Terraform Example"
  public_key = file("~/.ssh/id_rsa.pub")
}

module "docker" {
  source = "../.." # "syntaqx/docker/digitalocean"

  region           = "sfo2"
  prefix           = "example-"
  private_key_path = "~/.ssh/id_rsa"
  ssh_keys         = [digitalocean_ssh_key.default.id]
}

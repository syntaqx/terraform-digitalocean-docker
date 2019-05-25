# DigitalOcean Docker Terraform module

[![CircleCI](https://circleci.com/gh/syntaqx/swarm-api.svg?style=svg)](https://circleci.com/gh/syntaqx/swarm-api)

Terraform module to create and configure Docker Droplet resources on
DigitalOcean.

![module](https://raw.githubusercontent.com/syntaqx/terraform-digitalocean-docker/master/docs/readme-banner.png)

## Requirements

* [Terraform 0.12](https://www.terraform.io/) or newer

## Usage

```hcl
provider "digitalocean" {
}

resource "digitalocean_ssh_key" "default" {
  name       = "DigitalOcean Docker Example"
  public_key = file("~/.ssh/id_rsa.pub")
}

module "docker" {
  source  = "syntaqx/docker/digitalocean"
  version = "0.0.1"

  prefix           = "example-"
  private_key_path = "~/.ssh/id_rsa"
  ssh_keys         = [digitalocean_ssh_key.default.id]
}
```

## License

[MIT]: https://opensource.org/licenses/MIT

`terraform-digitalocean-docker` is open source software released under the
[MIT license][MIT].

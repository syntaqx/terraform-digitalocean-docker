data "digitalocean_image" "default" {
  slug = "docker-18-04"
}

resource "digitalocean_droplet" "instance" {
  count  = var.instance_count
  name   = format("%s-%02d-%s", var.prefix, count.index + 1, var.region)
  image  = data.digitalocean_image.default.slug
  size   = var.size
  region = var.region
  tags   = var.tags

  monitoring         = var.monitoring
  backups            = var.backups
  private_networking = var.private_networking
  ipv6               = var.ipv6

  connection {
    host        = self.ipv4_address
    type        = "ssh"
    agent       = false
    user        = "root"
    private_key = file(var.private_key_path)
    timeout     = "2m"
  }

  user_data = file("${path.module}/templates/cloud-config.yml")
  ssh_keys  = var.ssh_keys

  # Outputs cloud-init and waits for the boot to finish before allowing the
  # resource to be considered created. This asserts SSH connectivity can be
  # established and cloud-init is reporting as expected, tainting on failure.
  provisioner "remote-exec" {
    inline = [
      "test -f /var/log/cloud-init-output.log",
      "tail -f /var/log/cloud-init-output.log &",
      "until [ -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done",
    ]
  }


  # If the current Droplet is part of an existing swarm it attempts to leave.
  # Existing managers attempt to demote themselves before leaving.
  # If the current Droplet is part of an existing swarm it attempts to leave.
  # Existing managers attempt to demote themselves before leaving.
  provisioner "remote-exec" {
    when       = destroy
    on_failure = continue

    inline = [
      "swarm_role=$(docker node inspect --format '{{ .Spec.Role }}' self)",
      "node_id=$(docker node inspect --format '{{ .ID }}' self)",
      "if [ $swarm_role == 'manager' ]; then docker node demote $node_id; fi",
      "docker swarm leave -f",
    ]
  }

  # Zero downtime updates
  # https://github.com/nicholasjackson/terraform-digitalocean-lifecycle

  # Here we effectively implement a zero downtime lifecycle for docker engine.
  # Note that this does not observe application provisioning uptime. We instead
  # rely on cluster scheduling to place existing tasks while drains are occuring

  provisioner "local-exec" {
    command = "sh ./scripts/wait-for-docker.sh"
  }

  lifecycle {
    create_before_destroy = true
  }
}


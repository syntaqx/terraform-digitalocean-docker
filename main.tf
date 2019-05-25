data "template_file" "cloud_config" {
  template = file("${path.module}/templates/cloud-config.yml")
}

resource "digitalocean_droplet" "instance" {
  count  = var.instance_count
  name   = format("%s-%02d-%s", var.prefix, count.index + 1, var.region)
  image  = var.droplet_image
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

  user_data = data.template_file.cloud_config.rendered
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
  provisioner "remote-exec" {
    when       = destroy
    on_failure = continue

    inline = [
      "node_role=$(docker node inspect --format '{{ .Spec.Role }}' self)",
      "node_self=$(docker node inspect --format '{{ .ID }}' self)",
      "if [ $node_role == 'manager' ]; then docker node demote $node_self; fi",
      "docker swarm leave -f",
    ]
  }

  # Zero downtime updates
  # https://github.com/nicholasjackson/terraform-digitalocean-lifecycle

  # Here we effectively implement a zero downtime lifecycle for docker engine.
  # Note that this does not observe application provisioning uptime. We instead
  # rely on cluster scheduling to place existing tasks while drains are occuring

  # Note: This is currently disabled as the argument cannot be updatedd in-place
  # due to remote API limitations and it's currently leaving artifacts when
  # creation fails. This will be revisited when resources can be created without
  # module failure. Additionally, research is needed for random API failures.

  # provisioner "local-exec" {
  #   count   = var.zero_downtime_lifecycle == true ? 1 : 0
  #   command = "bash ${path.module}/scripts/wait-for-docker.sh"
  # }

  # lifecycle {
  #   create_before_destroy = var.zero_downtime_lifecycle
  # }
}

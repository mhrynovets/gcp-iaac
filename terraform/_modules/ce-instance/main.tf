resource "google_compute_instance" "ce-instances" {
  description               = "Compute Engine instances"
  count                     = "${var.instances-count}"
  name                      = "${var.common.prefix}${var.common.env}-ce${var.ident}-${count.index}${var.common.suffix}"
  machine_type              = "${var.instances-type}"
  tags                      = "${var.network-tags}"
  labels                    = "${var.labels}"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "${var.instances-os}"
    }
  }

  metadata = {
    index = "${count.index}",
    ssh-keys = join("\n", flatten(
      [for user in var.ssh_users : "${user.name}:${user.key} " if length(user.key) > 0],
    ))
  }

  network_interface {
    network    = "${var.vpc-name}"
    subnetwork = "${var.subnet-name}"
    network_ip = "${var.static-ip}"
    access_config {
    }
  }
  scheduling {
    automatic_restart = var.preemptible ? false : true
    preemptible       = var.preemptible ? true : false
  }
}

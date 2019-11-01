locals {
  name = "${var.common.prefix}${var.common.env}-allow-${var.protocol}-${join("-", var.ports)}${var.ident}${var.common.suffix}"
  tag  = var.all-instances ? "" : (var.custom_tag != "" ? var.custom_tag : local.name)
}

resource "google_compute_firewall" "fw-allow-ports" {
  description   = "Allow all instances with tag `${local.tag}` incomming connections on port `${join(", ", var.ports)}`"
  name          = "${local.name}"
  network       = "${var.vpc-name}"
  target_tags   = local.tag == "" ? [] : ["${local.tag}"]
  source_ranges = "${var.src-ip-range}"
  allow {
    protocol = "${var.protocol}"
    ports    = "${var.ports}"
  }
}


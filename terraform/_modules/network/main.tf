data "google_compute_network" "central-vpc" {
  count = var.create-peering-with != "" ? 1 : 0
  name  = "${var.create-peering-with}"
}

data "google_compute_subnetwork" "central-subnet" {
  count     = var.create-peering-with != "" ? 1 : 0
  self_link = "${data.google_compute_network.central-vpc[0].subnetworks_self_links[0]}"
}

resource "google_compute_network" "vpc" {
  name                    = "${var.common.prefix}${var.common.env}-vpc${var.ident}${var.common.suffix}"
  auto_create_subnetworks = "false"
  description             = "VPC for ${var.ident}"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.common.prefix}${var.common.env}-subnet${var.ident}${var.common.suffix}"
  ip_cidr_range = "${var.subnet-range}"
  network       = "${google_compute_network.vpc.self_link}"
  description   = "Subnet in ${google_compute_network.vpc.name} network."
}

resource "google_compute_network_peering" "peering-direct" {
  count        = var.create-peering-with != "" ? 1 : 0
  name         = "${var.common.prefix}${var.common.env}-peering-direct${var.ident}${var.common.suffix}"
  network      = "${google_compute_network.vpc.self_link}"
  peer_network = "${data.google_compute_network.central-vpc[0].self_link}"
}

resource "google_compute_network_peering" "peering-reverse" {
  count        = var.create-peering-with != "" ? 1 : 0
  name         = "${var.common.prefix}${var.common.env}-peering-reverse${var.ident}${var.common.suffix}"
  network      = "${data.google_compute_network.central-vpc[0].self_link}"
  peer_network = "${google_compute_network.vpc.self_link}"
}

output "vpc-name" {
  value = "${google_compute_network.vpc.name}"
}

output "vpc-self-link" {
  value = "${google_compute_network.vpc.self_link}"
}

output "subnet-name" {
  value = "${google_compute_subnetwork.subnet.name}"
}

output "subnet-self-link" {
  value = "${google_compute_subnetwork.subnet.self_link}"
}

output "central-vpc-self-link" {
  value = var.create-peering-with != "" ? "${data.google_compute_network.central-vpc[0].self_link}" : ""
}

output "central-subnet-self-links" {
  value = var.create-peering-with != "" ? "${data.google_compute_network.central-vpc[0].subnetworks_self_links}" : [""]
}

output "central-subnet-range" {
  value = var.create-peering-with != "" ? "${data.google_compute_subnetwork.central-subnet[0].ip_cidr_range}" : []
}

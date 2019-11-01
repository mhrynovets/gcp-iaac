output "public-ip" {
  value = "${google_compute_instance.ce-instances.*.network_interface.0.access_config.0.nat_ip}"
}

output "private-ip" {
  value = "${google_compute_instance.ce-instances.*.network_interface.0.network_ip}"
}

output "self-links" {
  value = "${google_compute_instance.ce-instances.*.self_link}"
}

output "names" {
  value = "${google_compute_instance.ce-instances.*.name}"
}

output "ids" {
  value = "${google_compute_instance.ce-instances.*.instance_id}"
}

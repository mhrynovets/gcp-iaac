output "frontend-names" {
  value = "${module.frontend.names}"
}

output "frontend-public-ip" {
  value = "${module.frontend.public-ip}"
}

output "frontend-private-ip" {
  value = "${module.frontend.private-ip}"
}

output "frontend-private-key" {
  value = "${module.ssh.private-key-location}"
}

output "frontend-inventory" {
  value = "${module.inventory.location}"
}

output "frontend-playbook" {
  value = "${local.common.ansible}/${var.ansible-script-name}"
}

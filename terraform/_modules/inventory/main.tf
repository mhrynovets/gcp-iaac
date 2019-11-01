data "template_file" "inventory-source" {
  count    = "${var.instances-count}"
  template = "$${node_name} ansible_ssh_host=$${ip} ansible_user=$${uname} ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $${bastion}'"
  vars = {
    node_name = "${element(var.instances-names, count.index)}"
    ip        = "${element(var.instances-addresses, count.index)}"
    uname     = "${var.instances-username}"
    bastion   = "${var.bastion_key_location != "" ? "-o ProxyCommand=\"ssh -o StrictHostKeyChecking=no -i ${var.bastion_key_location} -W %h:%p -q ${var.instances-username}@${var.bastion_public_ip}\"" : ""}"
  }
}

resource "local_file" "ansible_inventory" {
  content         = "${join("\n", data.template_file.inventory-source.*.rendered)}\n"
  filename        = "${var.inventory-location}"
  file_permission = "${var.inventory-permissions}"
}

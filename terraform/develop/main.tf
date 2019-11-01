
module "vars" {
  source = "../_modules/variables-prepare"
  path   = path.root
}

module "ssh_users" {
  source   = "../_modules/additional_ssh_pub_keys"
  key_path = var.user_ssh_public_key_path
}

module "network" {
  source = "../_modules/network"

  common              = local.common
  subnet-range        = var.subnet-range
  create-peering-with = var.central_vpc_name
}

module "fw-allow-http" {
  source = "../_modules/fw-allow-port"

  common   = local.common
  vpc-name = module.network.vpc-name
  ports    = ["80", "8080"]
}

module "fw-allow-ssh" {
  source = "../_modules/fw-allow-port"

  common   = local.common
  vpc-name = module.network.vpc-name
  src-ip-range = flatten([
    module.network.central-subnet-range,
    var.external_ip_access,
    "0.0.0.0/0"
  ])
  ports = ["22"]
}

module "fw-allow-ssh-internal-tcp" {
  source = "../_modules/fw-allow-port"

  common        = local.common
  ident         = "-internal-tcp"
  all-instances = true
  vpc-name      = module.network.vpc-name
  src-ip-range  = ["${var.subnet-range}"]
  ports         = ["0-65535"]
}

module "fw-allow-ssh-internal-udp" {
  source = "../_modules/fw-allow-port"

  common        = local.common
  ident         = "-internal-udp"
  all-instances = true
  vpc-name      = module.network.vpc-name
  src-ip-range  = ["${var.subnet-range}"]
  protocol      = "udp"
  ports         = ["0-65535"]
}

module "ssh" {
  source = "../_modules/ssh-keygen"

  ssh-private-key-location = var.ssh-private-key-path
  ssh-private-key-perm     = 440
}

module "frontend" {
  source = "../_modules/ce-instance"

  common         = local.common
  instances-type = var.vm-type
  network-tags   = ["${module.fw-allow-http.network-tag}", "${module.fw-allow-ssh.network-tag}"]
  vpc-name       = module.network.vpc-name
  subnet-name    = module.network.subnet-name
  preemptible    = true
  ssh_users = flatten([
    {
      key  = module.ssh.public-key,
      name = local.common.username
    },
    module.ssh_users.data
  ])
}

module "inventory" {
  source = "../_modules/inventory"

  instances-names       = "${module.frontend.names}"
  instances-addresses   = "${module.frontend.public-ip}"
  instances-username    = "${local.common.username}"
  inventory-location    = "${var.inventory-file-path}"
  inventory-permissions = 660
}


resource "null_resource" "provisioning" {
  depends_on = ["module.frontend"]
  triggers = {
    instance_ids = "${join(",", module.frontend.ids)}"
  }
  provisioner "local-exec" {
    command = "sleep 10 && bash ${local.common.project_root}/safe-ansible-playbook.sh ${module.inventory.location} ${module.ssh.private-key-location} ${local.common.ansible} ${var.ansible-script-name}"
  }
}

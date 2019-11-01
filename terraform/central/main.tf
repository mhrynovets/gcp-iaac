
module "vars" {
  source = "../_modules/variables-prepare"
  path   = path.root
}

module "network" {
  source = "../_modules/network"

  common       = local.common
  subnet-range = var.subnet-range
}

module "fw-allow-http" {
  source = "../_modules/fw-allow-port"

  common   = local.common
  vpc-name = module.network.vpc-name
  ports    = ["80", "8080", "8081"]
}

module "fw-allow-ssh-bastion" {
  source = "../_modules/fw-allow-port"

  common   = local.common
  vpc-name = module.network.vpc-name
  ports    = ["22"]
}


module "fw-allow-internal-tcp" {
  source = "../_modules/fw-allow-port"

  common        = local.common
  ident         = "-internal-tcp"
  all-instances = true
  vpc-name      = module.network.vpc-name
  src-ip-range  = ["${var.subnet-range}"]
  ports         = ["0-65535"]
}

module "fw-allow-internal-udp" {
  source = "../_modules/fw-allow-port"

  common        = local.common
  ident         = "-internal-udp"
  all-instances = true
  vpc-name      = module.network.vpc-name
  src-ip-range  = ["${var.subnet-range}"]
  protocol      = "udp"
  ports         = ["0-65535"]
}

module "ssh_users" {
  source   = "../_modules/additional_ssh_pub_keys"
  key_path = var.user_ssh_public_key_location
}

module "ssh_users_bastion" {
  source   = "../_modules/additional_ssh_pub_keys"
  key_path = var.bastion_public_keys_location
}

module "ssh-gen" {
  source = "../_modules/ssh-keygen"

  ssh_username             = var.username
  ssh-private-key-location = var.ssh_private_key_path
  ssh-private-key-perm     = 440
  attach-external          = module.ssh_users.data
}

module "ssh-gen-bastion" {
  source = "../_modules/ssh-keygen"

  ssh_username             = var.username
  ssh-private-key-location = var.ssh_bastion_private_key_path
  ssh-private-key-perm     = 400
  attach-external          = module.ssh_users_bastion.data
}

module "ce-bastion" {
  source = "../_modules/ce-instance"

  common         = local.common
  instances-type = var.vm-type
  ident          = "-bastion"
  ssh_users      = module.ssh-gen-bastion.data
  network-tags   = ["${module.fw-allow-http.network-tag}", "${module.fw-allow-ssh-bastion.network-tag}"]
  vpc-name       = module.network.vpc-name
  subnet-name    = module.network.subnet-name
}

module "ce-jenkins-master" {
  source = "../_modules/ce-instance"

  common         = local.common
  ident          = "-jenkins-master"
  instances-type = var.vm-type
  ssh_users      = module.ssh-gen.data
  network-tags   = ["${module.fw-allow-http.network-tag}"]
  vpc-name       = module.network.vpc-name
  subnet-name    = module.network.subnet-name
}

module "ce-nexus" {
  source = "../_modules/ce-instance"

  common         = local.common
  ident          = "-nexus"
  instances-type = var.vm-type
  ssh_users      = module.ssh-gen.data
  network-tags   = ["${module.fw-allow-http.network-tag}"]
  vpc-name       = module.network.vpc-name
  subnet-name    = module.network.subnet-name
}

module "inventory-bastion" {
  source = "../_modules/inventory"

  instances-names       = module.ce-bastion.names
  instances-addresses   = module.ce-bastion.public-ip
  instances-username    = var.username
  inventory-location    = "bastion.hosts"
  inventory-permissions = 660
}

module "inventory-jenkins-master" {
  source = "../_modules/inventory"

  instances-names       = module.ce-jenkins-master.names
  instances-addresses   = module.ce-jenkins-master.private-ip
  instances-username    = var.username
  inventory-location    = "jenkins-master.hosts"
  inventory-permissions = 660
  bastion_key_location  = abspath(module.ssh-gen-bastion.private-key-location)
  bastion_public_ip     = element(module.ce-bastion.public-ip, 0)

}

module "inventory-nexus" {
  source = "../_modules/inventory"

  instances-names       = module.ce-nexus.names
  instances-addresses   = module.ce-nexus.private-ip
  instances-username    = var.username
  inventory-location    = "nexus.hosts"
  inventory-permissions = 660
  bastion_key_location  = abspath(module.ssh-gen-bastion.private-key-location)
  bastion_public_ip     = element(module.ce-bastion.public-ip, 0)
}


resource "null_resource" "provisioning-bastion" {
  depends_on = ["module.ce-bastion"]
  triggers = {
    instance_ids = "${join(",", module.ce-bastion.ids)}"
  }
  provisioner "local-exec" {
    command = "sleep 10 && bash ${local.common.project_root}/safe-ansible-playbook.sh ${module.inventory-bastion.location} ${module.ssh-gen-bastion.private-key-location} ${local.common.ansible} ${var.bastion_ansible_script_name}"
  }
}

resource "null_resource" "provisioning-jenkins-master" {
  depends_on = ["module.ce-jenkins-master"]
  triggers = {
    instance_ids = "${join(",", module.ce-jenkins-master.ids)}"
  }
  provisioner "local-exec" {
    command = "sleep 15 && bash ${local.common.project_root}/safe-ansible-playbook.sh ${module.inventory-jenkins-master.location} ${module.ssh-gen.private-key-location} ${local.common.ansible} ${var.jenkins_master_ansible_script_name}"
  }
}

resource "null_resource" "provisioning-nexus" {
  depends_on = ["module.ce-nexus"]
  triggers = {
    instance_ids = "${join(",", module.ce-nexus.ids)}"
  }
  provisioner "local-exec" {
    command = "sleep 15 && bash ${local.common.project_root}/safe-ansible-playbook.sh ${module.inventory-nexus.location} ${module.ssh-gen.private-key-location} ${local.common.ansible} ${var.nexus_ansible_script_name}"
  }
}

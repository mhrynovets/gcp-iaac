locals {
  common = {
    prefix       = var.prefix,
    suffix       = var.suffix,
    env          = var.environment != "" ? var.environment : module.vars.path.dir,
    ansible      = var.env_ansible != "" ? var.env_ansible : module.vars.path.ansible,
    terraform    = var.env_terraform != "" ? var.env_terraform : module.vars.path.terraform,
    creds        = var.env_creds != "" ? var.env_creds : module.vars.path.creds,
    project_root = var.env_root != "" ? var.env_root : module.vars.path.project_root,
  }
}
variable "env_root" {
  description = "Root path to IaaC storage"
  default     = ""
  type        = string
}
variable "env_ansible" {
  description = "Absolute path to Ansible subdirectory in IaaC storage"
  default     = ""
  type        = string
}
variable "env_terraform" {
  description = "Absolute path to Terraform subdirectory in IaaC storage"
  default     = ""
  type        = string
}
variable "project" {
  description = "Project name to deploy infrastructure"
  type        = string
}
variable "region" {
  description = "Default region"
  default     = "europe-north1"
  type        = string
}
variable "zone" {
  description = "Default zone in region"
  default     = "europe-north1-a"
  type        = string
}
variable "environment" {
  description = "Level of environment"
  default     = ""
  type        = string
}
variable "vm-type" {
  description = "VM instances type"
  default     = "g1-small"
  type        = string
}
variable "vm-os" {
  description = "VM instances operating system"
  default     = "debian-cloud/debian-9"
  type        = string
}
variable "prefix" {
  description = "Global prefix for resource names"
  default     = "pref-"
  type        = string
}
variable "suffix" {
  description = "Global prefix for resource names"
  default     = "-suf"
  type        = string
}
variable "username" {
  description = "Username to attach ssh key"
  default     = "devOpsCat"
  type        = string
}
variable "central_vpc_name" {
  description = "Name of control VPC to create peering"
  default     = ""
  type        = string
}
variable "subnet-range" {
  description = "CIDR of private addresses for subnet"
  type        = string
}
variable "external_ip_access" {
  description = "Public CIDR range to provision resources"
  default     = []
  type        = list(string)
}
variable "ssh_private_key_path" {
  description = "Path to save private key to access instances"
  default     = "devops.pem"
  type        = string
}
variable "ssh_users" {
  description = "Users attach to instances"
  default     = [""]
  type        = list(string)
}
variable "user_ssh_public_key_location" {
  description = "Path, where stored custom users public keys"
  default     = "ssh_keys"
  type        = string
}
variable "ansible-script-name" {
  description = "Path to ansible script for provisioning"
  default     = ""
  type        = string
}
variable "env_creds" {
  description = "Path to google credentials file"
  default     = ""
  type        = string
}
variable "inventory-file-path" {
  description = "Where to store inventory file"
  default     = "hosts"
  type        = string
}
variable "preemptible" {
  description = "Create preemptible instance with lower pricing for 24 hours"
  default     = false
  type        = bool
}

variable "ssh_bastion_private_key_path" {
  description = "Path to save private key to access instances"
  default     = "devops-bastion.pem"
  type        = string
}

variable "bastion_ansible_script_name" {
  description = "Name of provisionong file for bastion"
  default     = "provision-bastion.yml"
  type        = string
}

variable "jenkins_master_ansible_script_name" {
  description = "Name of provisionong file for jenkins-master"
  default     = "provision-jenkins-master.yml"
  type        = string
}

variable "nexus_ansible_script_name" {
  description = "Name of provisionong file for nexus"
  default     = "provision-nexus.yml"
  type        = string
}

variable "bastion_public_keys_location" {
  description = "Directory, where users public keys for bastion are saved"
  default     = "./bastion_keys"
  type        = string
}

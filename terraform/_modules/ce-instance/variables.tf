variable "common" {
  description = "Common data for identifiers. Should define prefix, suffix and env parameters."
  default = {
    prefix   = ""
    suffix   = ""
    env      = ""
    username = "devops"
  }
  type = map(any)
}

variable "instances-count" {
  description = "Count of VMs to create"
  default     = 1
  type        = number
}

variable "ident" {
  description = "VM instances basename"
  default     = "-vm"
  type        = string
}

variable "instances-type" {
  description = "VM instances type"
  default     = "f1-micro"
  type        = string
}

variable "network-tags" {
  description = "Network tags to attach to instances"
  default     = []
  type        = list(any)
}

variable "labels" {
  description = "Labels to attach to instances"
  default     = {}
  type        = map(any)
}

variable "instances-os" {
  description = "VM instances operating system"
  default     = "debian-cloud/debian-9"
  type        = string
}

variable "vpc-name" {
  description = "VPC name to attach to instances"
  type        = string
}

variable "subnet-name" {
  description = "Subnet name to attach to instances"
  type        = string
}

variable "static-ip" {
  description = "Subnet name to attach to instances"
  default     = ""
  type        = string
}

variable "ssh_users" {
  description = "Users attach to instances"
  type        = list(map(string))
  #[{ name = "", key = "" }]
}

variable "preemptible" {
  description = "Create preemptible instance with lower pricing for 24 hours"
  default     = false
  type        = bool
}

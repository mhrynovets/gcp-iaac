variable "instances-count" {
  description = "Count of instances"
  default     = 1
  type        = number
}

variable "instances-names" {
  description = "List of instances names"
  type        = list(any)
}

variable "instances-addresses" {
  description = "List of instances addresses"
  type        = list(any)
}

variable "inventory-location" {
  description = "Path with file name, where inventory file will be stored"
  default     = "hosts"
  type        = string
}

variable "inventory-permissions" {
  description = "Permissions for inventory file"
  default     = 600
  type        = number
}

variable "instances-username" {
  description = "Username for SSH connection"
  type        = string
}

variable "bastion_key_location" {
  description = "Location of private bastion key for ssh-proxy"
  default     = ""
  type        = string
}

variable "bastion_public_ip" {
  description = "Public IP of bastion for ssh-proxy"
  default     = ""
  type        = string
}

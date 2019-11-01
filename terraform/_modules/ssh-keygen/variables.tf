variable "ssh-private-key-location" {
  description = "Path to save private key to access instances"
  default     = "devops.pem"
  type        = string
}

variable "ssh-private-key-perm" {
  description = "Permissions for saved private key"
  default     = 400
  type        = number
}

variable "ssh-algorithm" {
  description = "Algorithm to use by generating SSH key-pair"
  default     = "RSA"
  type        = string
}

variable "ssh_username" {
  description = "Username for generated key"
  type        = string
}

variable "attach-external" {
  description = "Attach external source of public keys and names"
  default     = null
  type        = list(map(string))
  #[{ name = "", key = "" }]
}

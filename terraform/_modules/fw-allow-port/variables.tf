variable "common" {
  description = "Common data for identifiers. Should define prefix, suffix and env parameters."
  default = {
    prefix = ""
    suffix = ""
    env    = ""
  }
  type = map(any)
}

variable "ident" {
  description = "VPC name to attach"
  default     = ""
  type        = string
}

variable "vpc-name" {
  description = "VPC name to attach"
  type        = string
}

variable "src-ip-range" {
  description = "Source range of addresses"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "protocol" {
  description = "Used protocol"
  default     = "tcp"
  type        = string
}

variable "ports" {
  description = "Used port"
  default     = ["80"]
  type        = list(string)
}

variable "custom_tag" {
  description = "Custom network tag"
  default     = ""
  type        = string
}

variable "all-instances" {
  description = "No network tag - all instances on VPC"
  default     = false
  type        = bool
}

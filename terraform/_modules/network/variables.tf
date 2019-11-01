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
  description = "VPC and subnet identifier"
  default     = ""
  type        = string

}

variable "subnet-range" {
  description = "CIDR range of addresses for subnet"
  type        = string

}

variable "create-peering-with" {
  description = "Name of VPC to create peering with"
  default     = ""
  type        = string

}

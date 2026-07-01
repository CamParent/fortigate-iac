variable "policy_name" {
  description = "Name of the firewall policy"
}

variable "src_interface" {
  description = "Source interface"
}

variable "dst_interface" {
  description = "Destination interface"
}

variable "src_address" {
  description = "Source address object name"
}

variable "nat_enabled" {
  description = "Enable NAT"
  default     = "enable"
}

variable "vdom" {
  description = "VDOM name"
  default     = "root"
}
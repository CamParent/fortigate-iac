variable "fortios_token" {
  description = "HQ FortiGate API token"
  sensitive   = true
}

variable "fortios_branch_token" {
  description = "Branch FortiGate API token"
  sensitive   = true
}

variable "fortigate_hq_host" {
  description = "HQ FortiGate IP"
  default     = "192.168.1.112"
}

variable "fortigate_branch_host" {
  description = "Branch FortiGate IP"
  default     = "192.168.1.113"
}

variable "vdom" {
  default = "root"
}

variable "lan_subnet" {
  default = "10.10.10.0/24"
}

variable "wan_interface" {
  default = "port1"
}

variable "lan_interface" {
  default = "port2"
}
terraform {
  required_providers {
    fortios = {
      source  = "fortinetdev/fortios"
      version = "~> 1.20"
    }
  }
}

provider "fortios" {
  hostname = var.fortigate_hq_host
  token    = var.fortios_token
  insecure = true
}

provider "fortios" {
  alias    = "hq"
  hostname = var.fortigate_hq_host
  token    = var.fortios_token
  insecure = true
}

provider "fortios" {
  alias    = "branch"
  hostname = var.fortigate_branch_host
  token    = var.fortios_branch_token
  insecure = true
}
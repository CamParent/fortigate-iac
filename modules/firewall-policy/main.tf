resource "fortios_firewall_policy" "policy" {
  name            = var.policy_name
  action          = "accept"
  schedule        = "always"
  nat             = var.nat_enabled
  logtraffic      = "all"
  update_if_exist = true

  srcintf {
    name = var.src_interface
  }

  dstintf {
    name = var.dst_interface
  }

  srcaddr {
    name = var.src_address
  }

  dstaddr {
    name = "all"
  }

  service {
    name = "ALL"
  }
}
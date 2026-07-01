# HQ Resources
resource "fortios_firewall_address" "servers" {
  provider = fortios.hq
  name     = "TF-Servers"
  subnet   = var.lan_subnet
  comment  = "Managed by Terraform"
}

resource "fortios_firewall_vip" "web_server" {
  provider = fortios.hq
  name     = "TF-WebServer-VIP"
  extip    = var.fortigate_hq_host
  extintf  = var.wan_interface
  mappedip {
    range = "192.168.2.10"
  }
  portforward = "enable"
  protocol    = "tcp"
  extport     = "8080"
  mappedport  = "80"
}

module "hq_lan_to_wan_policy" {
  source        = "./modules/firewall-policy"
  providers     = { fortios = fortios.hq }
  policy_name   = "TF-HQ-LAN-to-WAN"
  src_interface = var.lan_interface
  dst_interface = var.wan_interface
  src_address   = fortios_firewall_address.servers.name
  nat_enabled   = "enable"
  vdom          = var.vdom
}

# Branch Resources - requires licensed FortiGate
# resource "fortios_firewall_address" "branch_servers" {
#   provider = fortios.branch
#   name     = "TF-Branch-Servers"
#   subnet   = "10.20.0.0/24"
#   comment  = "Managed by Terraform"
# }

# module "branch_lan_to_wan_policy" {
#   source        = "./modules/firewall-policy"
#   providers     = { fortios = fortios.branch }
#   policy_name   = "TF-Branch-LAN-to-WAN"
#   src_interface = var.lan_interface
#   dst_interface = var.wan_interface
#   src_address   = fortios_firewall_address.branch_servers.name
#   nat_enabled   = "enable"
#   vdom          = var.vdom
# }
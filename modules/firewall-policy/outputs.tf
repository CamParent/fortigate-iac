output "policy_id" {
  description = "The ID of the created firewall policy"
  value       = fortios_firewall_policy.policy.policyid
}

output "policy_name" {
  description = "The name of the created firewall policy"
  value       = fortios_firewall_policy.policy.name
}
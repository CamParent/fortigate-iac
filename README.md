# FortiGate Infrastructure as Code (IaC)

Terraform-based infrastructure as code for managing FortiGate firewall configuration across HQ and Branch environments via the FortiOS REST API. Includes a fully automated GitHub Actions CI/CD pipeline using a self-hosted runner for local network access.

## Architecture

```
GitHub (Code + Secrets)
        │
        ▼
GitHub Actions (Self-Hosted Runner - Local Network)
        │
        ▼
Terraform (FortiOS Provider v1.24.1)
        │
        ├──▶ FortiGate HQ (192.168.1.112) - FortiOS 8.0
        └──▶ FortiGate Branch (192.168.1.113) - FortiOS 8.0
```

## What This Manages

- **Firewall Address Objects** — subnet definitions for network segmentation
- **Firewall Policies** — traffic control rules with NAT, logging, and service restrictions
- **Virtual IPs (VIPs)** — destination NAT for inbound traffic to internal servers
- **Multi-device support** — aliased Terraform providers for simultaneous HQ and Branch management

## Repository Structure

```
fortigate-iac/
├── .github/
│   └── workflows/
│       └── terraform.yml        # CI/CD pipeline
├── modules/
│   └── firewall-policy/         # Reusable firewall policy module
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── providers.tf
├── main.tf                      # Root resources
├── providers.tf                 # FortiOS provider config (HQ + Branch aliases)
├── variables.tf                 # Input variables
├── .gitignore                   # Excludes tfvars, state, and provider binaries
└── README.md
```

## CI/CD Pipeline

The GitHub Actions pipeline runs automatically on every push and pull request to main:

| Step | Trigger |
|------|---------|
| Terraform Init | Push + PR |
| Terraform Format Check | Push + PR |
| Terraform Plan | Push + PR |
| Terraform Apply | Push to main only |

A self-hosted runner on the local network provides direct API access to FortiGate devices without exposing management interfaces to the internet.

## Prerequisites

- FortiGate VM or physical device with API access enabled
- Terraform >= 1.0
- GitHub Actions self-hosted runner on the same network as FortiGate

## Setup

**1. Generate an API token on each FortiGate:**

```
config system api-user
    edit "terraform"
        set accprofile "super_admin"
        config trusthost
            edit 1
                set ipv4-trusthost 192.168.1.0 255.255.255.0
            next
        end
    next
end
execute api-user generate-key terraform
```

**2. Add tokens to GitHub Secrets:**
- `FORTIOS_TOKEN` — HQ FortiGate API token
- `FORTIOS_BRANCH_TOKEN` — Branch FortiGate API token

**3. Install and register a self-hosted GitHub Actions runner on your local network**

**4. Clone the repo and push to trigger the pipeline**

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `fortios_token` | HQ FortiGate API token | Required |
| `fortios_branch_token` | Branch FortiGate API token | Required |
| `fortigate_hq_host` | HQ FortiGate IP | 192.168.1.112 |
| `fortigate_branch_host` | Branch FortiGate IP | 192.168.1.113 |
| `lan_subnet` | LAN subnet to manage | 10.10.10.0/24 |
| `wan_interface` | WAN interface | port1 |
| `lan_interface` | LAN interface | port2 |

## Security Notes

- API tokens are stored as GitHub Secrets and never committed to the repository
- `terraform.tfvars` and `terraform.tfstate` are excluded via `.gitignore`
- Trusthost restrictions limit API access to the local management subnet
- All traffic policies include `logtraffic all` for audit compliance

## Related Projects

- [iac-foundation](https://github.com/CamParent/iac-foundation) — Azure hub-spoke infrastructure platform using Terraform and Bicep
- [ansible-netgen](https://github.com/CamParent/ansible-netgen) — Ansible network automation with Cisco IOS drift detection

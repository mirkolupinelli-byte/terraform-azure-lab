# Azure Terraform Lab – Load Balancer with Two Backend VMs

## Overview

This project deploys a simple Azure infrastructure using Terraform to simulate a load-balanced environment.

The goal is to distribute HTTP traffic across two backend virtual machines using an Azure Load Balancer.

---

## Architecture

Internet → Public IP (Load Balancer) → Load Balancer → Backend Pool → VM1 / VM2

---

## Components

* 1 Resource Group
* 1 Virtual Network
* 1 Subnet
* 2 Network Interfaces
* 2 Linux Virtual Machines (Ubuntu)
* 1 Public IP (Load Balancer)
* 1 Azure Load Balancer (Standard SKU)
* 1 Backend Address Pool
* 1 Health Probe (port 80)
* 1 Load Balancer Rule (port 80)

---

## Networking and Security

* Both VMs are deployed in the same subnet
* VMs do NOT have public IP addresses (private only)
* The Load Balancer exposes a single public IP
* NSG rules:

  * Allow HTTP (port 80) from the Internet
  * Allow SSH (port 22) only from a restricted IP for management

---

## How It Works

1. A request is sent to the Load Balancer public IP
2. The Load Balancer checks backend health using a probe on port 80
3. Traffic is forwarded to one of the backend VMs
4. The response is returned to the client

---

## Validation

Each VM was configured with a different response:

* VM1 → `VM1`
* VM2 → `VM2`

Testing with multiple requests:

```bash
curl http://<LOAD_BALANCER_PUBLIC_IP>
```

Result:

* VM1
* VM2
* VM1
* VM2

This confirms that traffic is being distributed correctly.

---

## Terraform Commands

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

---

## What I Learned

* Deploying Azure infrastructure using Terraform
* Designing a simple load-balanced architecture
* Configuring:

  * Load Balancer
  * Backend Address Pool
  * Health Probe
  * Load Balancer Rules
* Associating NICs to a backend pool
* Managing NSG rules for controlled access
* Troubleshooting common issues:

  * SKU mismatches (Basic vs Standard)
  * Incorrect resource references
  * Connectivity and timeout issues

---

## Notes

This project was built as a hands-on lab to strengthen Azure and Terraform skills.

Sensitive files and credentials are excluded from the repository.

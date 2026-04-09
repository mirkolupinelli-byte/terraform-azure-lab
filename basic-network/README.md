# Azure Terraform Lab – Basic Network

## Overview

This lab deploys a basic Azure network infrastructure using Terraform.

The goal is to build a simple environment with:

* a Virtual Network
* multiple subnets
* Network Security Groups (NSG)
* two Linux virtual machines

---

## Architecture

Virtual Network → Subnets → NSG → Virtual Machines

---

## Components

* 1 Resource Group
* 1 Virtual Network
* 2 Subnets (frontend / backend)
* 2 Network Security Groups
* 2 Network Interfaces
* 2 Linux Virtual Machines

---

## Networking and Security

* Each subnet is associated with a specific NSG
* NSG rules control inbound traffic
* SSH (port 22) is allowed for management
* Communication between VMs happens within the private network

---

## What I Learned

* How to create a Virtual Network and subnets in Azure
* How NSGs work and how to apply them to subnets
* How to deploy and connect multiple VMs
* How to control traffic with security rules
* Basic troubleshooting of Azure networking

---

## Terraform Commands

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

---

## Notes

This project is part of a hands-on Terraform learning path focused on Azure networking fundamentals.

Sensitive files and local configurations are excluded from the repository.

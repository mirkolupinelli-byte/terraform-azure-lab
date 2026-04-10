# Terraform Azure Storage Lab

## Overview

This lab demonstrates how to deploy and manage Azure Storage using Terraform.

The goal is to create a simple storage environment, upload a file, and test public vs private access to blobs.

---

## Architecture

* Resource Group
* Storage Account (Standard, LRS)
* Blob Container
* Blob (uploaded from local file)

---

## What I implemented

* Created a Storage Account using Terraform
* Created a Blob Container with configurable access level
* Uploaded a local file using Terraform (`source`)
* Tested access behavior:

  * Private container → file not accessible
  * Blob access → file accessible via URL

---

## Key Concepts

* Globally unique naming for Storage Accounts
* Difference between:

  * `private`
  * `blob`
  * `container` access levels
* Terraform resource dependencies
* Uploading files via `azurerm_storage_blob`

---

## Usage

```bash
terraform init
terraform plan
terraform apply
```

To destroy resources:

```bash
terraform destroy
```

---

## Notes

* Blob access depends on container access level
* Public access requires:

  * container access enabled
  * storage account networking allowing public access
* State files are excluded via `.gitignore`

---

## Author

Mirko Lupinelli

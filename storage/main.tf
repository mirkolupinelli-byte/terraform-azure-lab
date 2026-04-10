terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "lab" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage_test" {
  name                = "forzamochi"
  resource_group_name = azurerm_resource_group.lab.name
  location                 = azurerm_resource_group.lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  }
  resource "azurerm_storage_container" "container_test" {
  name                  = "files"
  storage_account_name    = azurerm_storage_account.storage_test.name
  container_access_type = "blob"
}
resource "azurerm_storage_blob" "blob_test" {
  name                   = "test.txt"
  storage_account_name   = azurerm_storage_account.storage_test.name
  storage_container_name = azurerm_storage_container.container_test.name
  type                   = "Block"
  source                 = "test.txt"
}
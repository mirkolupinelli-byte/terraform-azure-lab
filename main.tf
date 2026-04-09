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
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-lab2"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "subnet_frontend" {
  name                 = "subnet-frontend"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "subnet_backend" {
  name                 = "subnet-backend"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_public_ip" "pip" {
  name                = "pip-lab"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_network_security_group" "nsg_frontend" {
  name                = "nsg-frontend"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
      }
  }
resource "azurerm_network_security_group" "nsg_backend" {
  name                = "nsg-backend"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.4"
    destination_address_prefix = "*"
      }
  }
  resource "azurerm_network_interface" "nic_frontend" {
  name                = "nic-frontend"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_frontend.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
      }
}
  resource "azurerm_network_interface" "nic_backend" {
  name                = "nic-backend"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_backend.id
    private_ip_address_allocation = "Dynamic"
      }
}
resource "azurerm_subnet_network_security_group_association" "nsg_frontend" {
  subnet_id                 = azurerm_subnet.subnet_frontend.id
  network_security_group_id = azurerm_network_security_group.nsg_frontend.id
}
resource "azurerm_subnet_network_security_group_association" "nsg_backend" {
  subnet_id                 = azurerm_subnet.subnet_backend.id
  network_security_group_id = azurerm_network_security_group.nsg_backend.id
}
resource "azurerm_linux_virtual_machine" "vm_frontend" {
  name                = "vm-frontend"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = "Standard_B2ts_v2"

  admin_username = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_frontend.id
  ]

  admin_password = var.admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
resource "azurerm_linux_virtual_machine" "vm_backend" {
  name                = "vm-backend"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = "Standard_B2ts_v2"

  admin_username = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_backend.id
  ]

  admin_password = var.admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
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
  name                = var.vnet_name
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
 
   resource "azurerm_network_interface" "nic_frontend_vm1" {
  name                = "nic_frontend_VM1"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_frontend.id
    private_ip_address_allocation = "Dynamic"
      
    }
}
   resource "azurerm_network_interface" "nic_frontend_vm2" {
  name                = "nic_frontend_VM2"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_frontend.id
    private_ip_address_allocation = "Dynamic"
    }
}
resource "azurerm_linux_virtual_machine" "vm_frontend" {
  name                = "vm-frontend"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = "Standard_B2ts_v2"

  admin_username = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_frontend_vm1.id
  ]

  disable_password_authentication = true
  admin_ssh_key {
  username   = "azureuser"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3K6GL0jp0XYUPIRZULR/6cHPn2HjMPuUVI8A6FoK0E1dC/HvwEiHqyw1J+osjs2MIrgUq29Anc7fnjHLmIOcDNwjAU1M2uqxfCH/ZYLuh615M3AT62DIgKY6ABVkK3yi41huAbetKcVsJHYEEwp/nAg+AWmJOOIjjaznYnUeChC5KKaig+10Y9JH9jjJ2UTHqQUIBUpOMNsgUqaC+AZmYX4omIYgjo7ZlHePMkiDfarmpXZnby1+MWG8D9qQmCcW+YODGB0+MVOeVvNAYSQKPGYAJTjfbPpwvaen7KSkWsZI9BXS7EIv7v+/3nN+y09yRreUbrR+9q4TVxmULxwARnU8C3LjvrXgLKScQPXASWvFZWiyVWYhgP5OqpiMvnxLhxg4apT1olAcLfXU6Gq4tiKVQwfbeh/WkNfIkgzi3bafoX70XOlKtMfqJqPeXQcctFkxWQRwvkOVOCTCsslpr65YpL7++4waFV0jaLG1OZ9VX5sBzKbj7afSpoeGkWmOdtgjrBsLEpYD+y0eCL8UbhKCE4Bh6li4/x+f9DHGNlyHN3JdCNsUWD10iPha4na/mwHp9qP2lNzykDqAlmc6bWoadFKCV/reEyBaoyHpe0ch39kGX7fcFVYy+5ROKNr+jn/NaqDTlQnZfZ9P6HO5JsuED8nBQiv1QcxJgcpRsWQ== mirko@Mirko"
}

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
resource "azurerm_linux_virtual_machine" "vm_frontend2" {
  name                = "vm-frontend2"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = "Standard_B2ts_v2"

  admin_username = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_frontend_vm2.id
  ]

  disable_password_authentication = true
  admin_ssh_key {
  username   = "azureuser"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3K6GL0jp0XYUPIRZULR/6cHPn2HjMPuUVI8A6FoK0E1dC/HvwEiHqyw1J+osjs2MIrgUq29Anc7fnjHLmIOcDNwjAU1M2uqxfCH/ZYLuh615M3AT62DIgKY6ABVkK3yi41huAbetKcVsJHYEEwp/nAg+AWmJOOIjjaznYnUeChC5KKaig+10Y9JH9jjJ2UTHqQUIBUpOMNsgUqaC+AZmYX4omIYgjo7ZlHePMkiDfarmpXZnby1+MWG8D9qQmCcW+YODGB0+MVOeVvNAYSQKPGYAJTjfbPpwvaen7KSkWsZI9BXS7EIv7v+/3nN+y09yRreUbrR+9q4TVxmULxwARnU8C3LjvrXgLKScQPXASWvFZWiyVWYhgP5OqpiMvnxLhxg4apT1olAcLfXU6Gq4tiKVQwfbeh/WkNfIkgzi3bafoX70XOlKtMfqJqPeXQcctFkxWQRwvkOVOCTCsslpr65YpL7++4waFV0jaLG1OZ9VX5sBzKbj7afSpoeGkWmOdtgjrBsLEpYD+y0eCL8UbhKCE4Bh6li4/x+f9DHGNlyHN3JdCNsUWD10iPha4na/mwHp9qP2lNzykDqAlmc6bWoadFKCV/reEyBaoyHpe0ch39kGX7fcFVYy+5ROKNr+jn/NaqDTlQnZfZ9P6HO5JsuED8nBQiv1QcxJgcpRsWQ== mirko@Mirko"
}

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
resource "azurerm_public_ip" "pip_lb" {
  name                = "pip_lb"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb_test" {
  name                = "lb_test"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.pip_lb.id
  }
}
resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  loadbalancer_id = azurerm_lb.lb_test.id
  name            = "backend_address_pool"
}
resource "azurerm_network_interface_backend_address_pool_association" "nic_associate_lb1" {
  network_interface_id    = azurerm_network_interface.nic_frontend_vm1.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
}
resource "azurerm_network_interface_backend_address_pool_association" "nic_associate_lb2" {
  network_interface_id    = azurerm_network_interface.nic_frontend_vm2.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
}
resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.lb_test.id
  name            = "http-running-probe"
  port            = 80
}
resource "azurerm_lb_rule" "test" {
  name                = "first"
  loadbalancer_id     = azurerm_lb.lb_test.id
  backend_address_pool_ids = [
  azurerm_lb_backend_address_pool.lb_backend_pool.id
]
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  probe_id = azurerm_lb_probe.lb_probe.id
  frontend_ip_configuration_name = "frontend-ip-config"
}

output "lb_rule_id" {
  value = azurerm_lb_rule.test.id
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
       security_rule {
    name                       = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
      }
    }
    
 resource "azurerm_subnet_network_security_group_association" "nsg_frontend" {
  subnet_id                 = azurerm_subnet.subnet_frontend.id
  network_security_group_id = azurerm_network_security_group.nsg_frontend.id
  }
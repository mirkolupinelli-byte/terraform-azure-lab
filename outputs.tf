output "frontend_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}
output "frontend_private_ip" {
  value = azurerm_network_interface.nic_frontend.private_ip_address
}

output "backend_private_ip" {
  value = azurerm_network_interface.nic_backend.private_ip_address
}
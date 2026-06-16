output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "acr_login_server" {
  value = azurerm_container_registry.main.login_server
}

output "azure_vnet_name" {
  value = azurerm_virtual_network.main.name
}

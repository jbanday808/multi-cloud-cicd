output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "resource_group_id" {
  value = azurerm_resource_group.main.id
}

output "acr_login_server" {
  value = azurerm_container_registry.main.login_server
}

output "acr_name" {
  value = azurerm_container_registry.main.name
}

output "acr_id" {
  value = azurerm_container_registry.main.id
}

output "azure_vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "azure_vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "azure_subnet_id" {
  value = azurerm_subnet.main.id
}

output "network_security_group_id" {
  value = azurerm_network_security_group.app.id
}

output "route_table_id" {
  value = azurerm_route_table.main.id
}

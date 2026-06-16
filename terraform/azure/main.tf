resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = local.default_tags
}

resource "azurerm_container_registry" "main" {
  name                          = var.acr_name
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  sku                           = "Premium"
  admin_enabled                 = false
  anonymous_pull_enabled        = false
  public_network_access_enabled = var.acr_public_network_access_enabled

  tags = merge(local.default_tags, {
    Name = var.acr_name
  })
}

# Azure Monitor diagnostic settings placeholder:
# Add azurerm_monitor_diagnostic_setting resources here after a Log Analytics
# workspace or other monitoring destination is defined.

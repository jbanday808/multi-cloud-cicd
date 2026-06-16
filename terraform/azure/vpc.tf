resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.vnet_address_space

  tags = merge(local.default_tags, {
    Name = "${var.project_name}-vnet"
  })
}

resource "azurerm_subnet" "main" {
  name                 = "${var.project_name}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_address_prefix
}

resource "azurerm_network_security_group" "app" {
  name                = "${var.project_name}-app-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowApplicationInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = tostring(var.app_port)
    source_address_prefixes    = var.app_ingress_cidrs
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowOutboundInternet"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  tags = merge(local.default_tags, {
    Name = "${var.project_name}-app-nsg"
  })
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_route_table" "main" {
  name                = "${var.project_name}-rt"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  route {
    name           = "DefaultInternetRoute"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

  tags = merge(local.default_tags, {
    Name = "${var.project_name}-rt"
  })
}

resource "azurerm_subnet_route_table_association" "main" {
  subnet_id      = azurerm_subnet.main.id
  route_table_id = azurerm_route_table.main.id
}

# Azure Monitor diagnostic settings placeholder:
# Add azurerm_monitor_diagnostic_setting resources for the VNet, NSG, and route
# table after a Log Analytics workspace or other monitoring destination exists.

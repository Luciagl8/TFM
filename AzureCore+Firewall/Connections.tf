#Conexiones de las gateways
resource "azurerm_virtual_network_gateway_connection" "hub-to-Onprem" {
  name                = "hub-to-Onprem"
  location            = azurerm_resource_group.core-rg.location
  resource_group_name = azurerm_resource_group.core-rg.name
  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.GW-Hub.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.GW-onprem.id
  shared_key = "AzureA1b2C3"
}
resource "azurerm_virtual_network_gateway_connection" "Onprem-to-hub" {
  name                = "Onprem-to-hub"
  location            = azurerm_resource_group.core-rg.location
  resource_group_name = azurerm_resource_group.core-rg.name
  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.GW-onprem.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.GW-Hub.id
  shared_key = "AzureA1b2C3"
}
#Adding peering between fw and spoke
resource "azurerm_virtual_network_peering" "HubtoSpoke" {
  name                      = "HubtoSpoke"
  resource_group_name       = azurerm_resource_group.core-rg.name
  virtual_network_name      = azurerm_virtual_network.VNet-hub.name
  remote_virtual_network_id = azurerm_virtual_network.VNet-Spoke.id
  allow_gateway_transit = true
}
resource "azurerm_virtual_network_peering" "SpoketoHub" {
  name                      = "SpoketoHub"
  resource_group_name       = azurerm_resource_group.core-rg.name
  virtual_network_name      = azurerm_virtual_network.VNet-Spoke.name
  remote_virtual_network_id = azurerm_virtual_network.VNet-hub.id
  allow_forwarded_traffic      = true
  use_remote_gateways = true
}
#Rutas
resource "azurerm_route_table" "RT-Hub-Spoke" {
  name                          = "RT-Hub-Spoke"
  location                      = azurerm_resource_group.core-rg.location
  resource_group_name           = azurerm_resource_group.core-rg.name
  route {
    name           = "toSpoke"
    address_prefix = "10.6.0.0/16"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.4"
  }
}
resource "azurerm_subnet_route_table_association" "AssHubSpoke" {
  subnet_id      = azurerm_subnet.GatewaySubnetHub.id
  route_table_id = azurerm_route_table.RT-Hub-Spoke.id
}
resource "azurerm_route_table" "RT-SpokeSub" {
  name                          = "RT-SpokeSub"
  location                      = azurerm_resource_group.core-rg.location
  resource_group_name           = azurerm_resource_group.core-rg.name
  disable_bgp_route_propagation = true
  route {
    name           = "toFw"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.5.0.4"
  }
}
resource "azurerm_subnet_route_table_association" "Ass2" {
  subnet_id      = azurerm_subnet.SN-workload.id
  route_table_id = azurerm_route_table.RT-SpokeSub.id
}
resource "azurerm_resource_group" "core-rg" {
  name = "azure-core-rg"
  location = "eastus"
}
#Create the virtual network
resource "azurerm_virtual_network" "VNet-hub" {
  name = "VNet-hub"
  address_space = ["10.5.0.0/16"]
  resource_group_name = azurerm_resource_group.core-rg.name
  location = azurerm_resource_group.core-rg.location
}
#Subnet for Azure Firewall
resource "azurerm_subnet" "AzureFirewallSubnet" {
  name = "AzureFirewallSubnet" # mandatory name -do not rename-
  address_prefixes = ["10.5.0.0/24"]
  virtual_network_name = azurerm_virtual_network.VNet-hub.name
  resource_group_name = azurerm_resource_group.core-rg.name
}
#Subnet para gateway
resource "azurerm_subnet" "GatewaySubnetHub" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.core-rg.name
  virtual_network_name = azurerm_virtual_network.VNet-hub.name
  address_prefixes     = ["10.5.1.0/24"]
}
#Ip GW
resource "azurerm_public_ip" "gw-hub-pip" {
  name                = "gw-hub-pip"
  location            = azurerm_resource_group.core-rg.location
  resource_group_name = azurerm_resource_group.core-rg.name
  allocation_method = "Dynamic"
}
#Public Ip for Azure Firewall
resource "azurerm_public_ip" "firewall-pip" {
  name = "firewall-pip"
  resource_group_name = azurerm_resource_group.core-rg.name
  location = azurerm_resource_group.core-rg.location
  allocation_method = "Static"
  sku = "Standard"
}
#Azure Firewall
resource "azurerm_firewall" "firewall" {
  name = "FW01"
  resource_group_name = azurerm_resource_group.core-rg.name
  location = azurerm_resource_group.core-rg.location
  sku_name = "AZFW_VNet"
  sku_tier = "Standard"
  ip_configuration {
    name = "firewall-config"
    subnet_id = azurerm_subnet.AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.firewall-pip.id
  }
}
resource "azurerm_firewall_network_rule_collection" "RCNet" {
  name                = "RCNet"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = azurerm_resource_group.core-rg.name
  priority            = 100
  action              = "Allow"
  rule {
    name = "AllowWeb"
    source_addresses = [
      "192.168.1.0/24",
    ]
    destination_ports = [
      "80",
    ]
    destination_addresses = [
      "10.6.0.0/16"
    ]
    protocols = [
      "TCP"
    ]
  }
  rule {
    name = "AllowRDP"
    source_addresses = [
      "192.168.1.0/24",
    ]
    destination_ports = [
      "3389",
    ]
    destination_addresses = [
      "10.6.0.0/16"
    ]
    protocols = [
      "TCP"
    ]
  }
}
resource "azurerm_virtual_network_gateway" "GW-Hub" {
  name                = "GW-Hub"
  location            = azurerm_resource_group.core-rg.location
  resource_group_name = azurerm_resource_group.core-rg.name
  type     = "Vpn"
  vpn_type = "RouteBased"
  sku           = "Basic"
  ip_configuration {
    name= "GW-ipconf-hub"
    public_ip_address_id          = azurerm_public_ip.gw-hub-pip.id
    subnet_id                     = azurerm_subnet.GatewaySubnetHub.id
  }
}

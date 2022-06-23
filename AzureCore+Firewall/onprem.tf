resource "azurerm_virtual_network" "Vnet-Onprem" {
  name = "Vnet-Onprem"
  address_space = ["192.168.0.0/16"]
  resource_group_name = azurerm_resource_group.core-rg.name
  location = azurerm_resource_group.core-rg.location
}
resource "azurerm_subnet" "SubnetOnPrem" {
  name                 = "SubnetOnPrem"
  resource_group_name  = azurerm_resource_group.core-rg.name
  virtual_network_name = azurerm_virtual_network.Vnet-Onprem.name
  address_prefixes     = ["192.168.1.0/24"]
}
resource "azurerm_subnet" "GatewaySubnetOnprem" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.core-rg.name
  virtual_network_name = azurerm_virtual_network.Vnet-Onprem.name
  address_prefixes     = ["192.168.2.0/24"]
}
resource "azurerm_public_ip" "gw-onprem-pip" {
  name                = "gw-onprem-pip"
  location            = azurerm_resource_group.core-rg.location
  resource_group_name = azurerm_resource_group.core-rg.name
  allocation_method = "Dynamic"
}
#Create the gateway
resource "azurerm_virtual_network_gateway" "GW-onprem" {
  name                = "GW-onprem"
  location            = azurerm_resource_group.core-rg.location
  resource_group_name = azurerm_resource_group.core-rg.name
  type     = "Vpn"
  vpn_type = "RouteBased"
  sku           = "Basic"
  ip_configuration {
    name = "GW-ipconf-Onprem"
    public_ip_address_id          = azurerm_public_ip.gw-onprem-pip.id
    subnet_id                     = azurerm_subnet.GatewaySubnetOnprem.id
  }
}
resource "azurerm_network_interface" "nionprem" {
  name                = "nic-onprem"
  location            = azurerm_resource_group.core-rg.location
  resource_group_name = azurerm_resource_group.core-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SubnetOnPrem.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-pip.id
  }
}
resource "azurerm_public_ip" "vm-pip" {
  name                = "publicip1"
  resource_group_name = azurerm_resource_group.core-rg.name
  location            = azurerm_resource_group.core-rg.location
  allocation_method   = "Static"
}
resource "azurerm_windows_virtual_machine" "VM-Onprem" {
  name                = "VM-Onprem"
  resource_group_name = azurerm_resource_group.core-rg.name
  location            = azurerm_resource_group.core-rg.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nionprem.id,
  ]
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
}
# Security group for subnet 
resource "azurerm_network_security_group" "secgroup2" {
  name                = "secgroup-Onprem"
  resource_group_name = azurerm_resource_group.core-rg.name
  location            = azurerm_resource_group.core-rg.location
  security_rule {
    name                       = "Allow-RDP"
    priority                   = 200
    access                     = "Allow"
    direction                  = "Inbound"
    destination_port_range     = 3389
    protocol                   = "*" # rdp uses both
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# Associate subnet and network security group 
resource "azurerm_subnet_network_security_group_association" "secgroup-assoc2" {
  subnet_id                 = azurerm_subnet.SubnetOnPrem.id
  network_security_group_id = azurerm_network_security_group.secgroup2.id
}
#Create the virtual network
resource "azurerm_virtual_network" "VNet-Spoke" {
  name = "VNet-Spoke"
  address_space = ["10.6.0.0/16"]
  resource_group_name = azurerm_resource_group.core-rg.name
  location = azurerm_resource_group.core-rg.location
}
resource "azurerm_subnet" "SN-workload" {
  name                 = "SN-workload"
  resource_group_name  = azurerm_resource_group.core-rg.name
  virtual_network_name = azurerm_virtual_network.VNet-Spoke.name
  address_prefixes     = ["10.6.0.0/24"]
}
resource "azurerm_subnet" "GatewaySubnetSpoke" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.core-rg.name
  virtual_network_name = azurerm_virtual_network.VNet-Spoke.name
  address_prefixes     = ["10.6.1.0/24"]
}
# Security group for subnet 
resource "azurerm_network_security_group" "secgroup" {
  name                = "secgroup-Spoke"
  resource_group_name = azurerm_resource_group.core-rg.name
  location            = azurerm_resource_group.core-rg.location
  security_rule {
    name                       = "Allow-3389"
    priority                   = 200
    access                     = "Allow"
    direction                  = "Inbound"
    destination_port_range     = 3389
    protocol                   = "Tcp" # rdp uses both
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "10.6.0.0/24"
  }
  security_rule {
    name                       = "Allow-80"
    priority                   = 202
    access                     = "Allow"
    direction                  = "Inbound"
    destination_port_range     = 80
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "10.6.0.0/24"
  }
}
resource "azurerm_network_interface" "nispoke" {
  name                = "nic-spoke"
  location            = azurerm_resource_group.core-rg.location
  resource_group_name = azurerm_resource_group.core-rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SN-workload.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_windows_virtual_machine" "VM-Spoke" {
  name                = "VM-Spoke"
  resource_group_name = azurerm_resource_group.core-rg.name
  location            = azurerm_resource_group.core-rg.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nispoke.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
# Associate subnet and network security group 
resource "azurerm_subnet_network_security_group_association" "secgroup-assoc" {
  subnet_id                 = azurerm_subnet.SN-workload.id
  network_security_group_id = azurerm_network_security_group.secgroup.id
}



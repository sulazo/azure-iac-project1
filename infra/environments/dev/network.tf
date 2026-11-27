
resource "azurerm_virtual_network" "vnet-inventory-dev" {
  name                = "vnet-inventory-dev"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg-inventory-dev.name
  address_space       = ["10.0.0.0/24"]
  #   dns_servers         = ["10.0.0.4", "10.0.0.5"]


}

resource "azurerm_subnet" "snet-iis" {
  name                 = "snet-iis"
  resource_group_name  = azurerm_resource_group.rg-inventory-dev.name
  virtual_network_name = azurerm_virtual_network.vnet-inventory-dev.name
  address_prefixes     = ["10.0.0.0/26"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.rg-inventory-dev.name
  virtual_network_name = azurerm_virtual_network.vnet-inventory-dev.name
  address_prefixes     = ["10.0.0.64/26"]
}



resource "azurerm_network_interface" "main" {
  name                = "sman-nic"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg-inventory-dev.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.snet-iis.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}


resource "azurerm_network_security_group" "nsg-inventory-dev-iis" {
  name                = "nsg-inventory-dev-iis"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-inventory-dev.name
}

resource "azurerm_network_security_rule" "nsg-iis-rule" {
  name                        = "AllowHTTP"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg-inventory-dev.name
  network_security_group_name = azurerm_network_security_group.nsg-inventory-dev-iis.name

}
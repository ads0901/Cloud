# When authenticating using the Azure CLI or a Service Principal:
terraform {
  backend "azurerm" {
    storage_account_name = "${var.azure_stg_account}"
    container_name       = "${var.azure_stg_container}"
    key                  = "dev.terraform.tfstate"
  }
}
resource "azurerm_resource_group" "resourcegroup" {
  name     = "${var.azure_resource_group}"
  location = "${var.azure_location}"
}
resource "azurerm_public_ip" "avaecloud_publicip" {  //Here defined the public IP
  name                         = "avaecloudpublicip"  
  location                     = "${var.azure_location}"  
  resource_group_name          = "${azurerm_resource_group.resourcegroup.name}"  
  allocation_method            = "Dynamic"  
  idle_timeout_in_minutes      = 30  
  domain_name_label            = "avaecloudvm"  //Here defined the dns name 
}  
resource "azurerm_virtual_network" "avaecloud_vnet" {   //Here defined the virtual network
  name                = "avaecloudvnet"  
  address_space       = ["10.0.0.0/16"]  
  location            = "${var.azure_location}"  
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"  
}  
resource "azurerm_network_security_group" "avaecloud_nsg" {  //Here defined the network secrity group
  name                = "avaecloudnsg"  
  location            = "${var.azure_location}"  
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"  
  
  security_rule {  //Here opened https port
    name                       = "HTTPS"  
    priority                   = 1000  
    direction                  = "Inbound"  
    access                     = "Allow"  
    protocol                   = "Tcp"  
    source_port_range          = "*"  
    destination_port_range     = "443"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }    
  security_rule {   //Here opened remote desktop port
    name                       = "RDP"  
    priority                   = 110  
    direction                  = "Inbound"  
    access                     = "Allow"  
    protocol                   = "Tcp"  
    source_port_range          = "*"  
    destination_port_range     = "3389"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }  
}  
resource "azurerm_subnet" "avaecloud_subnet" {   //Here defined subnet
  name                 = "avaecloudsubnet"  
  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"  
  virtual_network_name = "${azurerm_virtual_network.avaecloud_vnet.name}"  
  address_prefix       = "10.0.2.0/24"  
}  
resource "azurerm_network_interface" "avaecloud_nic" {  //Here defined network interface
  name                      = "avaecloudnic"  
  location                  = "${var.azure_location}"  
  resource_group_name       = "${azurerm_resource_group.resourcegroup.name}"  
  network_security_group_id = "${azurerm_network_security_group.avaecloud_nsg.id}"  
  
  ip_configuration {  
    name                          = "avaecloudconfiguration"  
    subnet_id                     = "${azurerm_subnet.avaecloud_subnet.id}"  
    private_ip_address_allocation = "dynamic"  
    public_ip_address_id          = "${azurerm_public_ip.avaecloud_publicip.id}"  
  }  
} 
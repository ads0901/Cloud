terraform {
  backend "azurerm"{
  }
}
#Create Resource Groups
resource "azurerm_resource_group" "app" {
  name = "${var.app-rg}"
  location = "${var.location}"
  tags = {
    costcenter            = "${var.costcenter}"
    environmentinfo       = "${var.environmentinfo}"
    ownerinfo             = "${var.ownerinfo}"
    applicationname       = "${var.applicationname}"
    platform              = "${var.platform}"
    deploymenttype        = "${var.deploymenttype}"
    notificationdistlist  = "${var.notificationdistlist}"
    trproductid           = "${var.trproductid}"
  }
}
resource "azurerm_resource_group" "cs" {
  name = "${var.cs-rg}"
  location = "${var.location}"
  tags = {
    costcenter            = "${var.costcenter}"
    environmentinfo       = "${var.environmentinfo}"
    ownerinfo             = "${var.ownerinfo}"
    applicationname       = "${var.applicationname}"
    platform              = "${var.platform}"
    deploymenttype        = "${var.deploymenttype}"
    notificationdistlist  = "${var.notificationdistlist}"
    trproductid           = "${var.trproductid}"
  }
}
resource "azurerm_resource_group" "db" {
  name = "${var.db-rg}"
  location = "${var.location}"
  tags = {
    costcenter            = "${var.costcenter}"
    environmentinfo       = "${var.environmentinfo}"
    ownerinfo             = "${var.ownerinfo}"
    applicationname       = "${var.applicationname}"
    platform              = "${var.platform}"
    deploymenttype        = "${var.deploymenttype}"
    notificationdistlist  = "${var.notificationdistlist}"
    trproductid           = "${var.trproductid}"
  }
}
#########################################################################################
#Get Common Existing Resource Information
data "azurerm_resource_group" "vnet" {
  name = "${var.vnetrg}"
}
data "azurerm_resource_group" "mgmtrg" {
  name = "${var.mgmtrg}"
}
data "azurerm_recovery_services_vault" "mgmtrv" {
  name                = "${var.mgmtrv}"
  resource_group_name = "${data.azurerm_resource_group.mgmtrg.name}"
}
#########################################################################################
#Get SAP App Server Existing Resource Information
data "azurerm_subnet" "app" {
  name                 = "${var.app-subnet}"
  virtual_network_name = "${var.vnetname}"
  resource_group_name  = "${data.azurerm_resource_group.vnet.name}"
}
data "azurerm_recovery_services_protection_policy_vm" "app" {
  name                = "${var.app-policy}"
  recovery_vault_name = "${data.azurerm_recovery_services_vault.mgmtrv.name}"
  resource_group_name = "${data.azurerm_resource_group.mgmtrg.name}"
}
#########################################################################################
#Get SAP Central Services Server Existing Resource Information
data "azurerm_subnet" "cs" {
  name                 = "${var.cs-subnet}"
  virtual_network_name = "${var.vnetname}"
  resource_group_name  = "${data.azurerm_resource_group.vnet.name}"
}
data "azurerm_recovery_services_protection_policy_vm" "cs" {
  name                = "${var.cs-policy}"
  recovery_vault_name = "${data.azurerm_recovery_services_vault.mgmtrv.name}"
  resource_group_name = "${data.azurerm_resource_group.mgmtrg.name}"
}
#########################################################################################
#Get SAP Hana DB Server Existing Resource Information
data "azurerm_subnet" "db" {
  name                 = "${var.db-subnet}"
  virtual_network_name = "${var.vnetname}"
  resource_group_name  = "${data.azurerm_resource_group.vnet.name}"
}
#########################################################################################
#Create Proximity Placement Group
resource "azurerm_proximity_placement_group" "ppg" {
  name                = "${var.ppgname}"
  location            = "${azurerm_resource_group.db.location}"
  resource_group_name = "${azurerm_resource_group.db.name}"
  tags = {
    costcenter            = "${var.costcenter}"
    environmentinfo       = "${var.environmentinfo}"
    ownerinfo             = "${var.ownerinfo}"
    applicationname       = "${var.applicationname}"
    platform              = "${var.platform}"
    deploymenttype        = "${var.deploymenttype}"
    notificationdistlist  = "${var.notificationdistlist}"
    trproductid           = "${var.trproductid}"
  }
}

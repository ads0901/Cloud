#Common Variables
variable "location" {
  description = "Location of the resources"
  type = "string"
}
variable "vnetname" {
  description = "Virtual Network for the SAP Group Deployment"
  type = "string"
}
variable "vnetrg" {
  description = "Virtual Network Resource Group"
  type = "string"
}
variable "mgmtrg" {
  description = "Name of the Management Resource Group"
  type = "string"
}
variable "vmadmin" {
  description = "Local Server Admin"
  type = "string"
}
variable "vmadminpassword" {
  description = "Local Server Admin Password"
  type = "string"
}
variable "costcenter" {
  description = "Required Tag"
  type = "string"
}
variable "environmentinfo" {
  description = "Required Tag"
  type = "string"
}
variable "ownerinfo" {
  description = "Required Tag"
  type = "string"
}
variable "applicationname" {
  description = "Required Tag"
  type = "string"
}
variable "platform" {
  description = "Required Tag"
  type = "string"
}
variable "deploymenttype" {
  description = "Required Tag"
  type = "string"
}
variable "notificationdistlist" {
  description = "Required Tag"
  type = "string"
}
variable "trproductid" {
  description = "Required Tag"
  type = "string"
}
#########################################################################################
#SAP App Server Variables
variable "app-nodecount" {
  description = "Number of SAP App Servers to Deploy"
  type = "string"
  }
variable "app-vmsize" {
  description = "Size of the SAP App Servers Virtual Macines"
  type = "string"
}
variable "app-subnet" {
  description = "Subnet for the SAP App Servers"
  type = "string"
}
variable "app-rg" {
  description = "Resource Group Name for the SAP App Servers"
  type = "string"
}
variable "app-avset" {
  description = "Availability Set Name for the SAP App Servers"
  type = "string"
}
variable "app-name" {
  description = "Name for the SAP App Servers"
  type = "string"
}
variable "app-policy" {
  description = "Backup Policy for the SAP App Servers"
  type = "string"
}
#########################################################################################
#SAP Central Services Server Variables
variable "cs-vmsize" {
  description = "Size of the SAP Central Services Servers"
  type = "string"
}
variable "cs-subnet" {
  description = "Subnet for the SAP Central Services Servers"
  type = "string"
}
variable "cs-nodecount" {
  description = "Number of SAP Central Services Servers to Deploy"
  type = "string"
}
variable "cs-rg" {
  description = "Resource Group Name for the SAP Central Services Servers"
  type = "string"
}
variable "cs-avset" {
  description = "Availability Set Name for the SAP Central Services Servers"
  type = "string"
}
variable "cs-lb" {
  description = "Availability Set Name for the SAP Central Services Servers"
  type = "string"
}
variable "cs-name" {
  description = "Name of SAP Central Services Servers"
  type = "string"
}
variable "cs-policy" {
  description = "Backup Policy for the SAP Central Services Servers"
  type = "string"
}
#########################################################################################
#SAP Hana DB Server Variables
variable "db-vmsize" {
  description = "Size of the SAP Hana DB Servers"
  type = "string"
}
variable "db-subnet" {
  description = "Subnet for the SAP Hana DB Servers"
  type = "string"
}
variable "db-nodecount" {
  description = "Number of SAP Hana DB Servers to Deploy"
  type = "string"
}
variable "db-rg" {
  description = "Resource Group Name for the SAP Hana DB Servers"
  type = "string"
}
variable "db-avset" {
  description = "Availability Set Name for the SAP Hana DB Servers"
  type = "string"
}
variable "db-lb" {
  description = "Availability Set Name for the SAP Hana DB Servers"
  type = "string"
}
variable "db-name" {
  description = "Name of SAP Hana DB Servers"
  type = "string"
}
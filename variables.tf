variable "azure_resource_group" {
  type        = "string"
  description = "Name of the Azure Resource Group."

  default = "AvanadeTerraformRG"
}

variable "azure_location" {
  type        = "string"
  description = "Name of the Azure Location."

  default = "australiaeast"
}

variable "azure_appsvcplan" {
  type        = "string"
  description = "Name of the Azure App Service Plan."

  default = "abcd2019-appsvcplan"
}

variable "azure_appsvcact" {
  type        = "string"
  description = "Name of the Azure App Service Account"

  default = "abcd2019-app-svc"
}
variable "azure_stg_account" {
  type        = "string"
  description = "Name of the Azure Storage Account"

  default = "avanadestorageactname"
}
variable "azure_stg_container" {
  type        = "string"
  description = "Name of the Azure Storage Container"

  default = "kgavterracontainer"
}
variable "username" {  
  default = "avanade"  
}  
  
variable "password" {  
  default = "Password!1234"  
}  
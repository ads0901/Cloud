resource "azurerm_storage_account" "avaecloud_storageacc" {  //Here defined a storage account for disk
  name                     = "avaecloudstgacc"  
  resource_group_name      = "${azurerm_resource_group.resourcegroup.name}"  
  location                 = "${var.azure_location}"  
  account_tier             = "Standard"  
  account_replication_type = "GRS"  
}  
  
resource "azurerm_storage_container" "avaecloud_storagecont" {  //Here defined a storage account container for disk
  name                  = "avaecloudstoragecont"  
  resource_group_name   = "${azurerm_resource_group.resourcegroup.name}"  
  storage_account_name  = "${azurerm_storage_account.avaecloud_storageacc.name}"  
  container_access_type = "private"  
}  
  
resource "azurerm_managed_disk" "avaecloud_datadisk" {  //Here defined data disk structure
  name                 = "avaeclouddatadisk"  
  location             = "${var.azure_location}"  
  resource_group_name  = "${azurerm_resource_group.resourcegroup.name}"  
  storage_account_type = "Standard_LRS"  
  create_option        = "Empty"  
  disk_size_gb         = "1023"  
}  
  
resource "azurerm_virtual_machine" "avaecloud_vm" {  //Here defined virtual machine
  name                  = "avaecloudvm"  
  location              = "${var.azure_location}"  
  resource_group_name   = "${azurerm_resource_group.resourcegroup.name}"  
  network_interface_ids = ["${azurerm_network_interface.avaecloud_nic.id}"]  
  vm_size               = "Standard_DS2_v2"  //Here defined virtual machine size
  
  storage_image_reference {  //Here defined virtual machine OS
    publisher = "MicrosoftWindowsServer"  
    offer     = "WindowsServer"  
    sku       = "2019-Datacenter"  
    version   = "latest"  
  }  
 
  storage_os_disk {  //Here defined OS disk
    name              = "avaecloudosdisk"  
    caching           = "ReadWrite"  
    create_option     = "FromImage"  
    managed_disk_type = "Standard_LRS"  
    #  vhd_uri             = "${var.mycustimg}"
  }  
  
  storage_data_disk {  //Here defined actual data disk by referring to above structure
    name            = "${azurerm_managed_disk.avaecloud_datadisk.name}"  
    managed_disk_id = "${azurerm_managed_disk.avaecloud_datadisk.id}"  
    create_option   = "Attach"  
    lun             = 1  
    disk_size_gb    = "${azurerm_managed_disk.avaecloud_datadisk.disk_size_gb}"  
  }  
  
  os_profile {  //Here defined admin uid/pwd and also comupter name
    computer_name  = "avaecloudhost"  
    admin_username = "${var.username}"  
    admin_password = "${var.password}"  
  }  
  
  os_profile_windows_config {  //Here defined autoupdate config and also vm agent config
    enable_automatic_upgrades = true  
    provision_vm_agent        = true   
  }
}
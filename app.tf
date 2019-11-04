#Deploy SAP App Servers
resource "azurerm_availability_set" "app" {
  name                          = "${var.app-avset}"
  location                      = "${azurerm_resource_group.app.location}"
  resource_group_name           = "${azurerm_resource_group.app.name}"
  managed                       = true
  platform_update_domain_count  = "20"
  platform_fault_domain_count   = "3"
  proximity_placement_group_id  = "${azurerm_proximity_placement_group.ppg.id}"
  depends_on                    = ["azurerm_virtual_machine.db"]
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
resource "azurerm_network_interface" "app" {
  count                         = "${var.app-nodecount}"
  name                          = "nic-${var.app-name}-${format("%02d", count.index+1)}"
  location                      = "${azurerm_resource_group.app.location}"
  resource_group_name           = "${azurerm_resource_group.app.name}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = true
  ip_configuration {
    name                            = "ipconfig"
    subnet_id                       = "${data.azurerm_subnet.app.id}"
    private_ip_address_allocation   = "dynamic"
  }
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
resource "azurerm_managed_disk" "app" {
    count                = "${var.app-nodecount}"
    name                 = "disk-data-${var.app-name}-${format("%02d", count.index+1)}-01"
    location             = "${azurerm_resource_group.app.location}"
    resource_group_name  = "${azurerm_resource_group.app.name}"
    storage_account_type = "Premium_LRS"
    create_option        = "Empty"
    disk_size_gb         = "1024"
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
resource "azurerm_virtual_machine" "app" {
  count                         = "${var.app-nodecount}"
  name                          = "${var.app-name}-${format("%02d", count.index+1)}"
  location                      = "${azurerm_resource_group.app.location}"
  resource_group_name           = "${azurerm_resource_group.app.name}"
  network_interface_ids         = ["${element(azurerm_network_interface.app.*.id, count.index)}"]
  vm_size                       = "${var.app-vmsize}"
  availability_set_id           = "${azurerm_availability_set.app.id}"
  proximity_placement_group_id  = "${azurerm_proximity_placement_group.ppg.id}"
  depends_on                    = ["azurerm_virtual_machine.db"]
  storage_image_reference {
    publisher = "SUSE"
    offer     = "SLES-SAP-BYOS"
    sku       = "12-SP4"
    version   = "latest"
  }
  storage_os_disk {
    name              = "disk-os-${var.app-name}-${format("%02d", count.index+1)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  os_profile {
    computer_name  = "${var.app-name}-${format("%02d", count.index+1)}"
    admin_username = "${var.vmadmin}"
    admin_password = "${var.vmadminpassword}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  storage_data_disk {
    name              = "${element(azurerm_managed_disk.app.*.name, count.index)}"
    managed_disk_id   = "${element(azurerm_managed_disk.app.*.id, count.index)}"
    disk_size_gb      = "${element(azurerm_managed_disk.app.*.disk_size_gb, count.index)}"
    create_option     = "Attach"
    caching           = "ReadOnly"
    lun               = 0
  }
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
resource "azurerm_virtual_machine_extension" "app" {
  count                = "${var.app-nodecount}"
  name                 = "networkwatcheragent"
  location             = "${azurerm_resource_group.app.location}"
  resource_group_name  = "${azurerm_resource_group.app.name}"
  virtual_machine_name = "${element(azurerm_virtual_machine.app.*.name, count.index)}"
  publisher            = "Microsoft.Azure.NetworkWatcher"
  type                 = "NetworkWatcherAgentLinux"
  type_handler_version = "1.4"
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
resource "azurerm_virtual_machine_extension" "app2" {
  count                = "${var.app-nodecount}"
  name                 = "sleshardening"
  location             = "${azurerm_resource_group.app.location}"
  resource_group_name  = "${azurerm_resource_group.app.name}"
  virtual_machine_name = "${element(azurerm_virtual_machine.app.*.name, count.index)}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  depends_on           = ["azurerm_virtual_machine_extension.app"]

  settings = <<SETTINGS
      {
        "fileUris": ["https://raw.githubusercontent.com/a0099953/WMT/master/scripts/CIS-hardening-script-with-options.sh"],
        "commandToExecute": "sh CIS-hardening-script-with-options.sh"
    }
SETTINGS

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
resource "azurerm_virtual_machine_extension" "app3" {
  count                = "${var.app-nodecount}"
  name                 = "AzureEnhancedMonitorForLinux"
  location             = "${azurerm_resource_group.app.location}"
  resource_group_name  = "${azurerm_resource_group.app.name}"
  virtual_machine_name = "${element(azurerm_virtual_machine.app.*.name, count.index)}"
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "AzureEnhancedMonitorForLinux"
  type_handler_version = "3.0"
  depends_on           = ["azurerm_virtual_machine_extension.app2"]
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
resource "azurerm_recovery_services_protected_vm" "app" {
  count               = "${var.app-nodecount}"
  resource_group_name = "${data.azurerm_resource_group.mgmtrg.name}"
  recovery_vault_name = "${data.azurerm_recovery_services_vault.mgmtrv.name}"
  source_vm_id        = "${element(azurerm_virtual_machine.app.*.id, count.index)}"
  backup_policy_id    = "${data.azurerm_recovery_services_protection_policy_vm.app.id}"
}
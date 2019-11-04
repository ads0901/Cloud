#Deploy SAP Hana DB Servers
#create db servers availability set
resource "azurerm_availability_set" "db" {
  name                          = "${var.db-avset}"
  location                      = "${azurerm_resource_group.db.location}"
  resource_group_name           = "${azurerm_resource_group.db.name}"
  managed                       = true
  platform_update_domain_count  = "20"
  platform_fault_domain_count   = "3"
  proximity_placement_group_id  = "${azurerm_proximity_placement_group.ppg.id}"
  depends_on                    = ["azurerm_proximity_placement_group.ppg"]
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
#Create Load Balancer
resource "azurerm_lb" "db" {
  name                = "${var.db-lb}"
  location            = "${azurerm_resource_group.db.location}"
  resource_group_name = "${azurerm_resource_group.db.name}"
  frontend_ip_configuration {
    name                 = "hanafrontend"
    subnet_id            = "${data.azurerm_subnet.db.id}"
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
resource "azurerm_lb_backend_address_pool" "db" {
  resource_group_name = "${azurerm_resource_group.db.name}"
  loadbalancer_id     = "${azurerm_lb.db.id}"
  name                = "hanabackend"
  depends_on          = ["azurerm_lb.db"]
}
resource "azurerm_lb_probe" "db" {
  resource_group_name = "${azurerm_resource_group.db.name}"
  loadbalancer_id     = "${azurerm_lb.db.id}"
  name                = "hanaprobe"
  port                = 62503
  interval_in_seconds = 5
  number_of_probes    = 2
   depends_on          = ["azurerm_lb_backend_address_pool.db"]
}
resource "azurerm_lb_rule" "db1" {
  resource_group_name            = "${azurerm_resource_group.db.name}"
  loadbalancer_id                = "${azurerm_lb.db.id}"
  name                           = "hanaRule1"
  protocol                       = "Tcp"
  frontend_port                  = 30313
  backend_port                   = 30313
  frontend_ip_configuration_name = "hanafrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.db.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.db.id}"
  depends_on                     = ["azurerm_lb_probe.db"]
}
resource "azurerm_lb_rule" "db2" {
  resource_group_name            = "${azurerm_resource_group.db.name}"
  loadbalancer_id                = "${azurerm_lb.db.id}"
  name                           = "hanaRule2"
  protocol                       = "Tcp"
  frontend_port                  = 30315
  backend_port                   = 30315
  frontend_ip_configuration_name = "hanafrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.db.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.db.id}"
  depends_on                     = ["azurerm_lb_probe.db"]
}
resource "azurerm_lb_rule" "db3" {
  resource_group_name            = "${azurerm_resource_group.db.name}"
  loadbalancer_id                = "${azurerm_lb.db.id}"
  name                           = "hanaRule3"
  protocol                       = "Tcp"
  frontend_port                  = 30317
  backend_port                   = 30317
  frontend_ip_configuration_name = "hanafrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.db.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.db.id}"
  depends_on                     = ["azurerm_lb_probe.db"]
}
resource "azurerm_lb_rule" "db4" {
  resource_group_name            = "${azurerm_resource_group.db.name}"
  loadbalancer_id                = "${azurerm_lb.db.id}"
  name                           = "hanaRule4"
  protocol                       = "Tcp"
  frontend_port                  = 30340
  backend_port                   = 30340
  frontend_ip_configuration_name = "hanafrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.db.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.db.id}"
  depends_on                     = ["azurerm_lb_probe.db"]
}
resource "azurerm_lb_rule" "db5" {
  resource_group_name            = "${azurerm_resource_group.db.name}"
  loadbalancer_id                = "${azurerm_lb.db.id}"
  name                           = "hanaRule5"
  protocol                       = "Tcp"
  frontend_port                  = 30341
  backend_port                   = 30341
  frontend_ip_configuration_name = "hanafrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.db.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.db.id}"
  depends_on                     = ["azurerm_lb_probe.db"]
}
resource "azurerm_lb_rule" "db6" {
  resource_group_name            = "${azurerm_resource_group.db.name}"
  loadbalancer_id                = "${azurerm_lb.db.id}"
  name                           = "hanaRule6"
  protocol                       = "Tcp"
  frontend_port                  = 30342
  backend_port                   = 30342
  frontend_ip_configuration_name = "hanafrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.db.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.db.id}"
  depends_on                     = ["azurerm_lb_probe.db"]
}
# create a network interface
resource "azurerm_network_interface" "db" {
  count                         = "${var.db-nodecount}"
  name                          = "nic-${var.db-name}-${format("%02d", count.index+1)}"
  location                      = "${azurerm_resource_group.db.location}"
  resource_group_name           = "${azurerm_resource_group.db.name}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = true
  ip_configuration {
    name                            = "ipconfig"
    subnet_id                       = "${data.azurerm_subnet.db.id}"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.db.id}"]
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
resource "azurerm_network_interface_backend_address_pool_association" "db" {
  count                   = "${var.db-nodecount}"
  network_interface_id    = "${element(azurerm_network_interface.db.*.id, count.index)}"
  ip_configuration_name   = "ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.db.id}"
}
resource "azurerm_managed_disk" "db" {
    count                = "${var.db-nodecount}"
    name                 = "disk-data-${var.db-name}-${format("%02d", count.index+1)}-01"
    location             = "${azurerm_resource_group.db.location}"
    resource_group_name  = "${azurerm_resource_group.db.name}"
    storage_account_type = "Premium_LRS"
    create_option        = "Empty"
    disk_size_gb         = "1024"
  tags = {
    CostCenter            = "${var.CostCenter}"
    EnvironmentInfo       = "${var.EnvironmentInfo}"
    OwnerTeam             = "${var.OwnerTeam}"
    ApplicationName       = "${var.ApplicationName}"
    Platform              = "${var.Platform}"
    DeploymentType        = "${var.DeploymentType}"
    NotificationDistList  = "${var.NotificationDistList}"
  }
}
resource "azurerm_managed_disk" "db2" {
  count                = "${var.db-nodecount}"
  name                 = "disk-data-${var.db-name}-${format("%02d", count.index+1)}-02"
  location             = "${azurerm_resource_group.db.location}"
  resource_group_name  = "${azurerm_resource_group.db.name}"
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
resource "azurerm_managed_disk" "db3" {
  count                = "${var.db-nodecount}"
  name                 = "disk-data-${var.db-name}-${format("%02d", count.index+1)}-03"
  location             = "${azurerm_resource_group.db.location}"
  resource_group_name  = "${azurerm_resource_group.db.name}"
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
resource "azurerm_managed_disk" "db4" {
  count                = "${var.db-nodecount}"
  name                 = "disk-log-${var.db-name}-${format("%02d", count.index+1)}-01"
  location             = "${azurerm_resource_group.db.location}"
  resource_group_name  = "${azurerm_resource_group.db.name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "512"
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
resource "azurerm_managed_disk" "db5" {
  count                = "${var.db-nodecount}"
  name                 = "disk-log-${var.db-name}-${format("%02d", count.index+1)}-02"
  location             = "${azurerm_resource_group.db.location}"
  resource_group_name  = "${azurerm_resource_group.db.name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "512"
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
resource "azurerm_managed_disk" "db6" {
  count                = "${var.db-nodecount}"
  name                 = "disk-shared-${var.groupno}-${format("%02d", count.index+1)}-01"
  location             = "${azurerm_resource_group.db.location}"
  resource_group_name  = "${azurerm_resource_group.db.name}"
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
resource "azurerm_managed_disk" "db7" {
  count                = "${var.db-nodecount}"
  name                 = "disk-sap${var.db-name}-${format("%02d", count.index+1)}-01"
  location             = "${azurerm_resource_group.db.location}"
  resource_group_name  = "${azurerm_resource_group.db.name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "64"
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
resource "azurerm_managed_disk" "db8" {
  count                = "${var.db-nodecount}"
  name                 = "disk-backup-${var.db-name}-${format("%02d", count.index+1)}-01"
  location             = "${azurerm_resource_group.db.location}"
  resource_group_name  = "${azurerm_resource_group.db.name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "2048"
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
resource "azurerm_managed_disk" "db9" {
  count                = "${var.db-nodecount}"
  name                 = "disk-backup-${var.db-name}-${format("%02d", count.index+1)}-02"
  location             = "${azurerm_resource_group.db.location}"
  resource_group_name  = "${azurerm_resource_group.db.name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "2048"
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
resource "azurerm_virtual_machine" "db" {
  count                         = "${var.db-nodecount}"
  name                          = "${var.db-name}-${format("%02d", count.index+1)}"
  location                      = "${azurerm_resource_group.db.location}"
  resource_group_name           = "${azurerm_resource_group.db.name}"
  network_interface_ids         = ["${element(azurerm_network_interface.db.*.id, count.index)}"]
  vm_size                       = "${var.db-vmsize}"
  availability_set_id           = "${azurerm_availability_set.db.id}"
  proximity_placement_group_id  = "${azurerm_proximity_placement_group.ppg.id}"
  storage_image_reference {
    publisher = "SUSE"
    offer     = "SLES-SAP-BYOS"
    sku       = "12-SP4"
    version   = "latest"
  }
  storage_os_disk {
    name              = "disk-os-${var.db-name}-${format("%02d", count.index+1)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  os_profile {
    computer_name  = "${var.db-name}-${format("%02d", count.index+1)}"
    admin_username = "${var.vmadmin}"
    admin_password = "${var.vmadminpassword}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  storage_data_disk {
    name              = "${element(azurerm_managed_disk.db.*.name, count.index)}"
    managed_disk_id   = "${element(azurerm_managed_disk.db.*.id, count.index)}"
    disk_size_gb      = "${element(azurerm_managed_disk.db.*.disk_size_gb, count.index)}"
    create_option     = "Attach"
    caching           = "ReadOnly"
    lun               = 0
  }
  storage_data_disk {
    name              = "${element(azurerm_managed_disk.db2.*.name, count.index)}"
    managed_disk_id   = "${element(azurerm_managed_disk.db2.*.id, count.index)}"
    disk_size_gb      = "${element(azurerm_managed_disk.db2.*.disk_size_gb, count.index)}"
    create_option     = "Attach"
    caching           = "ReadOnly"
    lun               = 1
  }
  storage_data_disk {
    name              = "${element(azurerm_managed_disk.db3.*.name, count.index)}"
    managed_disk_id   = "${element(azurerm_managed_disk.db3.*.id, count.index)}"
    disk_size_gb      = "${element(azurerm_managed_disk.db3.*.disk_size_gb, count.index)}"
    create_option     = "Attach"
    caching           = "ReadOnly"
    lun               = 2
  }
  storage_data_disk {
    name              = "${element(azurerm_managed_disk.db4.*.name, count.index)}"
    managed_disk_id   = "${element(azurerm_managed_disk.db4.*.id, count.index)}"
    disk_size_gb      = "${element(azurerm_managed_disk.db4.*.disk_size_gb, count.index)}"
    create_option     = "Attach"
    caching           = "None"
    lun               = 3
  }
  storage_data_disk {
    name              = "${element(azurerm_managed_disk.db5.*.name, count.index)}"
    managed_disk_id   = "${element(azurerm_managed_disk.db5.*.id, count.index)}"
    disk_size_gb      = "${element(azurerm_managed_disk.db5.*.disk_size_gb, count.index)}"
    create_option     = "Attach"
    caching           = "None"
    lun               = 4
  }
  storage_data_disk {
    name              = "${element(azurerm_managed_disk.db6.*.name, count.index)}"
    managed_disk_id   = "${element(azurerm_managed_disk.db6.*.id, count.index)}"
    disk_size_gb      = "${element(azurerm_managed_disk.db6.*.disk_size_gb, count.index)}"
    create_option     = "Attach"
    caching           = "ReadOnly"
    lun               = 5
  }
  storage_data_disk {
    name              = "${element(azurerm_managed_disk.db7.*.name, count.index)}"
    managed_disk_id   = "${element(azurerm_managed_disk.db7.*.id, count.index)}"
    disk_size_gb      = "${element(azurerm_managed_disk.db7.*.disk_size_gb, count.index)}"
    create_option     = "Attach"
    caching           = "ReadOnly"
    lun               = 6
  }
  storage_data_disk {
    name              = "${element(azurerm_managed_disk.db8.*.name, count.index)}"
    managed_disk_id   = "${element(azurerm_managed_disk.db8.*.id, count.index)}"
    disk_size_gb      = "${element(azurerm_managed_disk.db8.*.disk_size_gb, count.index)}"
    create_option     = "Attach"
    caching           = "ReadOnly"
    lun               = 7
  }
  storage_data_disk {
    name              = "${element(azurerm_managed_disk.db9.*.name, count.index)}"
    managed_disk_id   = "${element(azurerm_managed_disk.db9.*.id, count.index)}"
    disk_size_gb      = "${element(azurerm_managed_disk.db9.*.disk_size_gb, count.index)}"
    create_option     = "Attach"
    caching           = "ReadOnly"
    lun               = 8
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
resource "azurerm_virtual_machine_extension" "db" {
  count                = "${var.db-nodecount}"
  name                 = "networkwatcheragent"
  location             = "${azurerm_resource_group.db.location}"
  resource_group_name  = "${azurerm_resource_group.db.name}"
  virtual_machine_name = "${element(azurerm_virtual_machine.db.*.name, count.index)}"
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
resource "azurerm_virtual_machine_extension" "db2" {
  count                = "${var.db-nodecount}"
  name                 = "sleshardening"
  location             = "${azurerm_resource_group.db.location}"
  resource_group_name  = "${azurerm_resource_group.db.name}"
  virtual_machine_name = "${element(azurerm_virtual_machine.db.*.name, count.index)}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  depends_on                     = ["azurerm_virtual_machine_extension.db"]
  settings = <<SETTINGS
      {
        "fileUris": ["https://raw.githubusercontent.com/a0099953/WMT/master/scripts/wmt-sleshardening.sh"],
        "commandToExecute": "ls"
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
resource "azurerm_virtual_machine_extension" "db3" {
  count                = "${var.db-nodecount}"
  name                 = "AzureEnhancedMonitorForLinux"
  location             = "${azurerm_resource_group.db.location}"
  resource_group_name  = "${azurerm_resource_group.db.name}"
  virtual_machine_name = "${element(azurerm_virtual_machine.db.*.name, count.index)}"
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "AzureEnhancedMonitorForLinux"
  type_handler_version = "3.0"
  depends_on           = ["azurerm_virtual_machine_extension.db2"]
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
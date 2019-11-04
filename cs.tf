#Deploy SAP Central Services Servers
#create cs servers availability set
resource "azurerm_availability_set" "cs" {
  name                          = "${var.cs-avset}"
  location                      = "${azurerm_resource_group.cs.location}"
  resource_group_name           = "${azurerm_resource_group.cs.name}"
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
#Create Load Balancer
resource "azurerm_lb" "cs" {
  name                = "${var.cs-lb}"
  location            = "${azurerm_resource_group.cs.location}"
  resource_group_name = "${azurerm_resource_group.cs.name}"
  frontend_ip_configuration {
    name              = "ersfrontend"
    subnet_id         = "${data.azurerm_subnet.cs.id}"
  }
  frontend_ip_configuration {
    name                  = "xscsfrontend"
    subnet_id             = "${data.azurerm_subnet.cs.id}"
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
resource "azurerm_lb_backend_address_pool" "cs-ers" {
  resource_group_name = "${azurerm_resource_group.cs.name}"
  loadbalancer_id     = "${azurerm_lb.cs.id}"
  name                = "ersbackend"
  depends_on          = ["azurerm_lb.cs"]
}
resource "azurerm_lb_backend_address_pool" "cs-xscs" {
  resource_group_name = "${azurerm_resource_group.cs.name}"
  loadbalancer_id     = "${azurerm_lb.cs.id}"
  name                = "xscsbackend"
  depends_on          = ["azurerm_lb.cs"]
}
resource "azurerm_lb_probe" "cs-ers" {
  resource_group_name = "${azurerm_resource_group.cs.name}"
  loadbalancer_id     = "${azurerm_lb.cs.id}"
  name                = "ersprobe"
  port                = 62101
  interval_in_seconds = 5
  number_of_probes    = 2
   depends_on          = ["azurerm_lb_backend_address_pool.cs-ers"]
}
resource "azurerm_lb_probe" "cs-xscs" {
  resource_group_name = "${azurerm_resource_group.cs.name}"
  loadbalancer_id     = "${azurerm_lb.cs.id}"
  name                = "xscsprobe"
  port                = 62000
  interval_in_seconds = 5
  number_of_probes    = 2
   depends_on          = ["azurerm_lb_backend_address_pool.cs-xscs"]
}
resource "azurerm_lb_rule" "cs-xscs" {
  resource_group_name            = "${azurerm_resource_group.cs.name}"
  loadbalancer_id                = "${azurerm_lb.cs.id}"
  name                           = "xscsRule1"
  protocol                       = "Tcp"
  frontend_port                  = 3600
  backend_port                   = 3600
  frontend_ip_configuration_name = "xscsfrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cs-xscs.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.cs-xscs.id}"
  depends_on                     = ["azurerm_lb_probe.cs-xscs"]

}
resource "azurerm_lb_rule" "cs-xscs2" {
  resource_group_name            = "${azurerm_resource_group.cs.name}"
  loadbalancer_id                = "${azurerm_lb.cs.id}"
  name                           = "xscsRule2"
  protocol                       = "Tcp"
  frontend_port                  = 3900
  backend_port                   = 3900
  frontend_ip_configuration_name = "xscsfrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cs-xscs.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.cs-xscs.id}"
  depends_on                     = ["azurerm_lb_probe.cs-xscs"]
}
resource "azurerm_lb_rule" "cs-xscs3" {
  resource_group_name            = "${azurerm_resource_group.cs.name}"
  loadbalancer_id                = "${azurerm_lb.cs.id}"
  name                           = "xscsRule3"
  protocol                       = "Tcp"
  frontend_port                  = 8100
  backend_port                   = 8100
  frontend_ip_configuration_name = "xscsfrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cs-xscs.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.cs-xscs.id}"
  depends_on                     = ["azurerm_lb_probe.cs-xscs"]
}
resource "azurerm_lb_rule" "cs-xscs4" {
  resource_group_name            = "${azurerm_resource_group.cs.name}"
  loadbalancer_id                = "${azurerm_lb.cs.id}"
  name                           = "xscsRule4"
  protocol                       = "Tcp"
  frontend_port                  = 50013
  backend_port                   = 50013
  frontend_ip_configuration_name = "xscsfrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cs-xscs.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.cs-xscs.id}"
  depends_on                     = ["azurerm_lb_probe.cs-xscs"]
}
resource "azurerm_lb_rule" "cs-xscs5" {
  resource_group_name            = "${azurerm_resource_group.cs.name}"
  loadbalancer_id                = "${azurerm_lb.cs.id}"
  name                           = "xscsRule5"
  protocol                       = "Tcp"
  frontend_port                  = 50014
  backend_port                   = 50014
  frontend_ip_configuration_name = "xscsfrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cs-xscs.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.cs-xscs.id}"
  depends_on                     = ["azurerm_lb_probe.cs-xscs"]
}
resource "azurerm_lb_rule" "cs-xscs6" {
  resource_group_name            = "${azurerm_resource_group.cs.name}"
  loadbalancer_id                = "${azurerm_lb.cs.id}"
  name                           = "xscsRule6"
  protocol                       = "Tcp"
  frontend_port                  = 50016
  backend_port                   = 50016
  frontend_ip_configuration_name = "xscsfrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cs-xscs.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.cs-xscs.id}"
  depends_on                     = ["azurerm_lb_probe.cs-xscs"]
}
resource "azurerm_lb_rule" "cs-ers" {
  resource_group_name            = "${azurerm_resource_group.cs.name}"
  loadbalancer_id                = "${azurerm_lb.cs.id}"
  name                           = "ersRule1"
  protocol                       = "Tcp"
  frontend_port                  = 3301
  backend_port                   = 3301
  frontend_ip_configuration_name = "ersfrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cs-ers.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.cs-ers.id}"
  depends_on                     = ["azurerm_lb_probe.cs-ers"]
}
resource "azurerm_lb_rule" "cs-ers2" {
  resource_group_name            = "${azurerm_resource_group.cs.name}"
  loadbalancer_id                = "${azurerm_lb.cs.id}"
  name                           = "ersRule2"
  protocol                       = "Tcp"
  frontend_port                  = 50113
  backend_port                   = 50113
  frontend_ip_configuration_name = "ersfrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cs-ers.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.cs-ers.id}"
  depends_on                     = ["azurerm_lb_probe.cs-ers"]
}
resource "azurerm_lb_rule" "cs-ers3" {
  resource_group_name            = "${azurerm_resource_group.cs.name}"
  loadbalancer_id                = "${azurerm_lb.cs.id}"
  name                           = "ersRule3"
  protocol                       = "Tcp"
  frontend_port                  = 50114
  backend_port                   = 50114
  frontend_ip_configuration_name = "ersfrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cs-ers.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.cs-ers.id}"
  depends_on                     = ["azurerm_lb_probe.cs-ers"]
}
resource "azurerm_lb_rule" "cs-ers4" {
  resource_group_name            = "${azurerm_resource_group.cs.name}"
  loadbalancer_id                = "${azurerm_lb.cs.id}"
  name                           = "ersRule4"
  protocol                       = "Tcp"
  frontend_port                  = 50116
  backend_port                   = 50116
  frontend_ip_configuration_name = "ersfrontend"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.cs-ers.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${azurerm_lb_probe.cs-ers.id}"
  depends_on                     = ["azurerm_lb_probe.cs-ers"]
}
# create a network interface
resource "azurerm_network_interface" "cs" {
  count                         = "${var.cs-nodecount}"
  name                          = "nic-${var.cs-name}-${format("%02d", count.index+1)}"
  location                      = "${azurerm_resource_group.cs.location}"
  resource_group_name           = "${azurerm_resource_group.cs.name}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = true
  ip_configuration {
    name                                    = "ipconfig"
    subnet_id                               = "${data.azurerm_subnet.cs.id}"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.cs-ers.id}"]
    private_ip_address_allocation           = "dynamic"
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
resource "azurerm_network_interface_backend_address_pool_association" "cs-ers" {
  count                   = "${var.cs-nodecount}"
  network_interface_id    = "${element(azurerm_network_interface.cs.*.id, count.index)}"
  ip_configuration_name   = "ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.cs-ers.id}"
}
resource "azurerm_virtual_machine" "cs" {
  count                         = "${var.cs-nodecount}"
  name                          = "${var.cs-name}-${format("%02d", count.index+1)}"
  location                      = "${azurerm_resource_group.cs.location}"
  resource_group_name           = "${azurerm_resource_group.cs.name}"
  network_interface_ids         = ["${element(azurerm_network_interface.cs.*.id, count.index)}"]
  vm_size                       = "${var.cs-vmsize}"
  availability_set_id           = "${azurerm_availability_set.cs.id}"
  proximity_placement_group_id  = "${azurerm_proximity_placement_group.ppg.id}"
  depends_on                    = ["azurerm_virtual_machine.db"]
  storage_image_reference {
    publisher = "SUSE"
    offer     = "SLES-SAP-BYOS"
    sku       = "12-SP4"
    version   = "latest"
  }
  storage_os_disk {
    name              = "disk-os-${var.cs-name}-${format("%02d", count.index+1)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  os_profile {
    computer_name  = "${var.cs-name}-${format("%02d", count.index+1)}"
    admin_username = "${var.vmadmin}"
    admin_password = "${var.vmadminpassword}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
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
resource "azurerm_virtual_machine_extension" "cs" {
  count                = "${var.cs-nodecount}"
  name                 = "networkwatcheragent"
  location             = "${azurerm_resource_group.cs.location}"
  resource_group_name  = "${azurerm_resource_group.cs.name}"
  virtual_machine_name = "${element(azurerm_virtual_machine.cs.*.name, count.index)}"
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
resource "azurerm_virtual_machine_extension" "cs2" {
  count                = "${var.cs-nodecount}"
  name                 = "sleshardening"
  location             = "${azurerm_resource_group.cs.location}"
  resource_group_name  = "${azurerm_resource_group.cs.name}"
  virtual_machine_name = "${element(azurerm_virtual_machine.cs.*.name, count.index)}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  depends_on           = ["azurerm_virtual_machine_extension.cs"]
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
resource "azurerm_virtual_machine_extension" "cs3" {
  count                = "${var.cs-nodecount}"
  name                 = "AzureEnhancedMonitorForLinux"
  location             = "${azurerm_resource_group.cs.location}"
  resource_group_name  = "${azurerm_resource_group.cs.name}"
  virtual_machine_name = "${element(azurerm_virtual_machine.cs.*.name, count.index)}"
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "AzureEnhancedMonitorForLinux"
  type_handler_version = "3.0"
  depends_on           = ["azurerm_virtual_machine_extension.cs2"]
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
resource "azurerm_recovery_services_protected_vm" "cs" {
  count               = "${var.cs-nodecount}"
  resource_group_name = "${data.azurerm_resource_group.mgmtrg.name}"
  recovery_vault_name = "${data.azurerm_recovery_services_vault.mgmtrv.name}"
  source_vm_id        = "${element(azurerm_virtual_machine.app.*.id, count.index)}"
  backup_policy_id    = "${data.azurerm_recovery_services_protection_policy_vm.cs.id}"
}
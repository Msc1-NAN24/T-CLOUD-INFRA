output "vm_cp_name" {
  value = azurerm_dev_test_linux_virtual_machine.control-plan.name
}

output "vm_worker_1" {
  value = azurerm_dev_test_linux_virtual_machine.worker[0].name
}

output "vm_worker_2" {
  value = azurerm_dev_test_linux_virtual_machine.worker[1].name
}


#output "ip_cp" {
#  value = azurerm_dev_test_linux_virtual_machine.control-plan.public_ip_address
#}


output "ip_cp" {
  value = join("", [azurerm_dev_test_linux_virtual_machine.control-plan.name, ".westeurope.cloudapp.azure.com"])
}
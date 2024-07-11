output "ip_cp" {
  value = join("", [azurerm_dev_test_linux_virtual_machine.control-plan.name, var.azure_suffix])
}

output "ip_worker_1" {
  value = join("", [azurerm_dev_test_linux_virtual_machine.worker[0].name, var.azure_suffix])
}

output "ip_worker_2" {
  value = join("", [azurerm_dev_test_linux_virtual_machine.worker[1].name, var.azure_suffix])
}
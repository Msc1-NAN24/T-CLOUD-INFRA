terraform apply -replace main.tfplan -replace=azurerm_dev_test_linux_virtual_machine.control-plan
terraform apply -replace main.tfplan -replace=azurerm_dev_test_linux_virtual_machine.worker[0]
terraform apply -replace main.tfplan -replace=azurerm_dev_test_linux_virtual_machine.worker[1]
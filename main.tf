/*variable "SSH_KEY" {
  type = any
  description = "The SSH key to use for the Virtual Machine."
  nullable = true
}*/

# Configuration du fournisseur Azure
provider "azurerm" {
  features {}
}

# Définition du groupe de ressources existant
data "azurerm_resource_group" "existing" {
  name = "t-clo-902-nts-0"
}

# Définition du DevTest Lab existant
data "azurerm_dev_test_lab" "existing" {
  name                = "t-clo-902-nts-0"
  resource_group_name = data.azurerm_resource_group.existing.name
}

# Création des machines virtuelles dans le DevTest Lab
resource "azurerm_dev_test_linux_virtual_machine" "worker" {
  count               = 2
  name                = "worker-vm-iac-${count.index}"
  location            = data.azurerm_dev_test_lab.existing.location
  resource_group_name = data.azurerm_dev_test_lab.existing.resource_group_name
  lab_name            = data.azurerm_dev_test_lab.existing.name
  ssh_key             = file("~/.ssh/id_rsa.pub")


  # Définit l'image de la machine virtuelle
  gallery_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"
  }

  size                   = var.vm_size
  username               = var.vm_username
  password               = var.vm_password
  storage_type           = "Standard"
  lab_virtual_network_id = "/subscriptions/1eb5e572-df10-47a3-977e-b0ec272641e4/resourcegroups/t-clo-902-nts-0/providers/microsoft.devtestlab/labs/t-clo-902-nts-0/virtualnetworks/t-clo-902-nts-0"
  lab_subnet_name        = "t-clo-902-nts-0Subnet"
}

resource "azurerm_dev_test_linux_virtual_machine" "control-plan" {
  name                = "control-plane-vm-iac"
  location            = data.azurerm_dev_test_lab.existing.location
  resource_group_name = data.azurerm_dev_test_lab.existing.resource_group_name
  lab_name            = data.azurerm_dev_test_lab.existing.name
  ssh_key             = file("~/.ssh/id_rsa.pub")

  gallery_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"
  }

  size                   = var.vm_size
  username               = var.vm_username
  password               = var.vm_password
  storage_type           = "Standard"
  lab_virtual_network_id = "/subscriptions/1eb5e572-df10-47a3-977e-b0ec272641e4/resourcegroups/t-clo-902-nts-0/providers/microsoft.devtestlab/labs/t-clo-902-nts-0/virtualnetworks/t-clo-902-nts-0"
  lab_subnet_name        = "t-clo-902-nts-0Subnet"
}
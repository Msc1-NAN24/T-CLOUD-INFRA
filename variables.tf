variable "vm_username" {
  type        = string
  description = "The username for the Virtual Machine."
  nullable    = false
}

variable "vm_password" {
  type        = string
  description = "The password for the Virtual Machine."
  nullable    = false
}

variable "vm_size" {
  type        = string
  description = "The size of the Virtual Machine."
  nullable    = false
  default     = "Standard_A4_v2"
}

variable "azure_suffix" {
  type        = string
  description = "The suffix to be added to the Azure resources."
  nullable    = false
  default     = ".westeurope.cloudapp.azure.com"
}
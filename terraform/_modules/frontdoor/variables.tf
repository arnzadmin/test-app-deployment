variable "name" {
  description = "The name of the Front Door profile."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the Front Door profile."
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "frontend_app_hostname" {
  description = "The default hostname of the frontend web app."
  type        = string
}

variable "storage_account_hostname" {
  description = "The hostname of the storage account blob endpoint."
  type        = string
}

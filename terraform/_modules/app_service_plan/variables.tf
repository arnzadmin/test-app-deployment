variable "name" {
  description = "The name of the App Service Plan."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the App Service Plan."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "kind" {
  description = "The kind of the App Service Plan (Linux or Windows)."
  type        = string
  default     = "Linux"
}

variable "sku_tier" {
  description = "The SKU tier for the App Service Plan."
  type        = string
}

variable "sku_size" {
  description = "The SKU size for the App Service Plan."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

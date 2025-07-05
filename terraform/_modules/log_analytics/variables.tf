variable "name" {
  description = "The name of the Log Analytics Workspace."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the Log Analytics Workspace."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "sku" {
  description = "The SKU of the Log Analytics Workspace."
  type        = string
  default     = "PerGB2018"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

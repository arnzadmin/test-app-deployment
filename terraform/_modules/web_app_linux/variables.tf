variable "name" {
  description = "The name of the Web App."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the Web App."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "app_service_plan_id" {
  description = "The ID of the App Service Plan."
  type        = string
}

variable "linux_fx_version" {
  description = "The runtime stack for the Web App (e.g., NODE|20-lts)."
  type        = string
}

variable "vnet_route_all_enabled" {
  description = "Whether to enable VNet route all."
  type        = bool
  default     = false
}

variable "app_settings" {
  description = "A map of app settings."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "The name of the Key Vault."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the Key Vault."
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the Key Vault."
  type        = string
  default     = "standard"
}

variable "enable_rbac_authorization" {
  description = "Enable RBAC authorization for the Key Vault."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

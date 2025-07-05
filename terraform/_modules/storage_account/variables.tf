variable "name" {
  description = "The name of the Storage Account."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the Storage Account."
  type        = string
}

variable "account_tier" {
  description = "The tier of the Storage Account."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type for the Storage Account."
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

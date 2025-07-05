variable "name" {
  description = "The name of the Virtual Network."
  type        = string
  default     = "vnet"
}

variable "address_space" {
  description = "The address space for the Virtual Network."
  type        = list(string)
}

variable "location" {
  description = "The Azure region to deploy the Virtual Network."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "subnet_names" {
  description = "A list of subnet names."
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "A list of subnet address prefixes."
  type        = list(string)
}

variable "subnet_service_endpoints" {
  description = "A list of lists, where each sublist contains the service endpoints for the corresponding subnet. Use an empty list for subnets with no endpoints."
  type        = list(list(string))
  default     = []
}

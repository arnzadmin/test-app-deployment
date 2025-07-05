variable "name" {
  description = "The name of the Cosmos DB account."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the Cosmos DB account."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "offer_type" {
  description = "The offer type for Cosmos DB."
  type        = string
  default     = "Standard"
}

variable "kind" {
  description = "The kind of Cosmos DB account (e.g., MongoDB)."
  type        = string
  default     = "MongoDB"
}

variable "consistency_policy" {
  description = "The consistency policy for Cosmos DB."
  type        = string
  default     = "Session"
}

variable "mongo_server_version" {
  description = "The MongoDB server version."
  type        = string
  default     = "4.2"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "vnet_rule" {
  description = "A list of objects with subnet_id for VNet rules."
  type = list(object({
    subnet_id = string
  }))
  default = []
}

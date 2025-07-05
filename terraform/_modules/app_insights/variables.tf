variable "name" {
  description = "The name of the Application Insights resource."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the Application Insights resource."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "application_type" {
  description = "The type of Application Insights (e.g., web)."
  type        = string
  default     = "web"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

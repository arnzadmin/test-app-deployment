variable "environment" {
  description = "The environment for which the resources are being created (e.g., dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "eastasia"
}

variable "project" {
  description = "The name of the project"
  type        = string
  default     = "test-app"
}

variable "team" {
  description = "The team responsible for the resources"
  type        = string
  default     = "infra"
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
  default     = "7f140b64-b162-4127-95cc-987f3e55428a" # Replace with actual tenant ID
}

variable "tags" {
  description = "Tags that are required to be applied to the resources"
  type        = map(string)
  default = {
    application     = "test-app"
    cost-center     = ""
    environment     = "dev"
    infra           = ""
    project-manager = ""
    backend-dev     = ""
    Frontend-dev    = ""
  }
}

terraform {
  required_version = ">= 1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "arnz-infra"

    workspaces {
      name = "arnz-infra-tfc-workspace"
    }
  }
}

provider "azurerm" {
  features {}
  storage_use_azuread = true
  subscription_id     = "6b819501-a8cb-4c81-8ec3-d62bae3fe593"
}

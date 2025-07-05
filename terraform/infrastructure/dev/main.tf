# Root Terraform module for scalable Azure web application architecture
# This configuration deploys:
# - 1 Resource Group
# - 1 App Service Plan
# - 2 App Services (frontend, backend)
# - Cosmos DB for MongoDB (vCore)
# - Azure Storage Account
# - Private VNet with subnets
# - Private Endpoints for Cosmos DB and Storage
# - VNet integration for backend App Service
# - Azure Front Door (public HTTPS for frontend)
# - Azure Key Vault (with secret references)
# - User-Assigned Managed Identity
# - Application Insights (frontend & backend)
# - Diagnostic Settings to Log Analytics
# - Get the Client ID of the User-Assigned Managed Identity using Azure CLI
# - az identity show --name uami-testapp-infra-dev --resource-group rg-testapp-infra-dev --query clientId -o tsv
# All resources are deployed in the same region and grouped under a single resource group.

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project}-${var.team}-${var.environment}"
  location = var.location
  tags     = var.tags
}

module "network" {
  source              = "../../_modules/vnet"
  name                = "vnet-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = ["10.10.0.0/16"]
  # Subnets: frontend, backend, private-endpoints, cosmosdb, storage, appgw (add more as needed)
  subnet_prefixes = [
    "10.10.1.0/24", # frontend
    "10.10.2.0/24", # backend
    "10.10.3.0/24", # private-endpoints (shared)
    "10.10.4.0/24", # cosmosdb (dedicated)
    "10.10.5.0/24", # storage (dedicated)
    # "10.10.6.0/24", # appgw (future)
  ]
  subnet_names = [
    "frontend",
    "backend",
    "private-endpoints",
    "cosmosdb",
    "storage"
    # "appgw"
  ]
  subnet_service_endpoints = [
    [],                          # frontend
    [],                          # backend
    ["Microsoft.AzureCosmosDB"], # private-endpoints (shared, CosmosDB)
    ["Microsoft.AzureCosmosDB"], # cosmosdb (dedicated)
    ["Microsoft.Storage"],       # storage (dedicated)
    # [] # appgw
  ]
  tags = var.tags
}

module "app_service_plan" {
  source              = "../../_modules/app_service_plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  kind                = "Linux"
  sku_tier            = "PremiumV3"
  sku_size            = "P0v3"
  name                = "asp-${var.project}-${var.environment}"
  tags                = var.tags
}

module "frontend_app" {
  source              = "../../_modules/web_app_linux"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  app_service_plan_id = module.app_service_plan.app_service_plan_id
  name                = "app-${var.project}-web-${var.environment}"
  linux_fx_version    = "NODE|20-lts"
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = module.frontend_app_insights.instrumentation_key
    WEBSITE_RUN_FROM_PACKAGE       = 1
  }
  tags = var.tags
}

module "backend_app" {
  source                 = "../../_modules/web_app_linux"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = var.location
  app_service_plan_id    = module.app_service_plan.app_service_plan_id
  name                   = "app-${var.project}-api-${var.environment}"
  linux_fx_version       = "NODE|20-lts"
  vnet_route_all_enabled = true
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = module.backend_app_insights.instrumentation_key
    #COSMOSDB_CONN_STRING           = module.cosmosdb.connection_strings[0]
    STORAGE_ACCOUNT_CONN_STRING = module.storage.primary_connection_string
    WEBSITE_RUN_FROM_PACKAGE    = 1
    KEYVAULT_URI                = module.keyvault.vault_uri
  }
  tags = var.tags
}

module "cosmosdb" {
  source               = "../../_modules/cosmosdb"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = var.location
  name                 = "cosmos-${var.project}-${var.environment}"
  kind                 = "MongoDB"
  offer_type           = "Standard"
  consistency_policy   = "Session"
  mongo_server_version = "4.2"
  vnet_rule            = [{ subnet_id = module.network.vnet_subnets[2] }]
  tags                 = var.tags
}

module "storage" {
  source                   = "../../_modules/storage_account"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  name                     = "sttestapp${var.environment}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

module "keyvault" {
  source                    = "../../_modules/keyvault"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = var.location
  name                      = "kvtestapp${var.environment}"
  tenant_id                 = var.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true
  tags                      = var.tags
}

data "azurerm_client_config" "current" {}

# resource "azurerm_user_assigned_identity" "main" {
#   name                = "uami-${var.project}-${var.team}-${var.environment}"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = var.location
#   tags                = var.tags
# }

data "azurerm_user_assigned_identity" "uami" {
  name                = "uami-arnz-infra-tfc"
  resource_group_name = "rg-arnz-infra-uai-manual"
}

module "frontend_app_insights" {
  source              = "../../_modules/app_insights"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = "appi-${var.project}-web-${var.environment}"
  application_type    = "web"
  tags                = var.tags
}

module "backend_app_insights" {
  source              = "../../_modules/app_insights"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = "appi-${var.project}-api-${var.environment}"
  application_type    = "web"
  tags                = var.tags
}

module "log_analytics" {
  source              = "../../_modules/log_analytics"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = "log-${var.project}-${var.environment}"
  tags                = var.tags
}

# Azure Front Door (public HTTPS for frontend)
module "frontdoor" {
  source                   = "../../_modules/frontdoor"
  resource_group_name      = azurerm_resource_group.rg.name
  name                     = "afd-${var.project}-${var.environment}"
  tags                     = var.tags
  frontend_app_hostname    = module.frontend_app.default_site_hostname
  storage_account_hostname = module.storage.primary_blob_endpoint_hostname
}



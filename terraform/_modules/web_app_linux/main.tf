resource "azurerm_linux_web_app" "app" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.app_service_plan_id
  site_config {
    vnet_route_all_enabled = var.vnet_route_all_enabled
  }
  app_settings = var.app_settings
  tags         = var.tags
}


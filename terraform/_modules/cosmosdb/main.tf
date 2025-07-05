resource "azurerm_cosmosdb_account" "mongodb" {
  name                              = var.name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  offer_type                        = var.offer_type
  kind                              = var.kind
  is_virtual_network_filter_enabled = length(var.vnet_rule) > 0 ? true : false
  consistency_policy {
    consistency_level = var.consistency_policy
  }
  geo_location {
    location          = var.location
    failover_priority = 0
  }
  capabilities {
    name = "EnableMongo"
  }
  mongo_server_version = var.mongo_server_version
  tags                 = var.tags

  dynamic "virtual_network_rule" {
    for_each = var.vnet_rule
    content {
      id = virtual_network_rule.value.subnet_id
    }
  }
}

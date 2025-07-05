## --- ADVANCED FRONT DOOR TUNING (Uncomment to enable) ---
# resource "azurerm_cdn_frontdoor_route" "web_advanced" {
#   name                         = "web-route-advanced"
#   cdn_frontdoor_endpoint_id    = azurerm_cdn_frontdoor_endpoint.afd.id
#   cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.frontend.id
#   cdn_frontdoor_origin_ids     = [azurerm_cdn_frontdoor_origin.frontend.id]
#   supported_protocols          = ["Http", "Https"]
#   patterns_to_match            = ["/*"]
#   forwarding_protocol          = "MatchRequest"
#   cache {
#     query_string_caching_behavior = "IgnoreQueryString"
#     compression_enabled           = true
#     # Uncomment below to override cache duration for static assets
#     # cache_duration = "00:10:00"
#   }
#   enabled = true
#   # Uncomment below to enable WAF policy association
#   # waf_policy_link_id = azurerm_cdn_frontdoor_waf_policy.example.id
# }

# resource "azurerm_cdn_frontdoor_route" "videos_advanced" {
#   name                         = "videos-route-advanced"
#   cdn_frontdoor_endpoint_id    = azurerm_cdn_frontdoor_endpoint.afd.id
#   cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.storage.id
#   cdn_frontdoor_origin_ids     = [azurerm_cdn_frontdoor_origin.storage.id]
#   supported_protocols          = ["Http", "Https"]
#   patterns_to_match            = ["/videos/*"]
#   forwarding_protocol          = "MatchRequest"
#   cache {
#     query_string_caching_behavior = "IgnoreQueryString"
#     compression_enabled           = true
#     # cache_duration = "01:00:00" # 1 hour cache for videos
#   }
#   enabled = true
#   # waf_policy_link_id = azurerm_cdn_frontdoor_waf_policy.example.id
# }

# resource "azurerm_cdn_frontdoor_waf_policy" "example" {
#   name                = "afd-waf-policy"
#   resource_group_name = var.resource_group_name
#   sku_name            = "Standard_AzureFrontDoor"
#   managed_rule {
#     type    = "DefaultRuleSet"
#     version = "1.0"
#   }
#   # Add custom rules as needed
# }
resource "azurerm_cdn_frontdoor_profile" "afd" {
  name                = var.name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "afd" {
  name                     = "${var.name}-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id
}

# Add more resources for backend pools, routing rules, etc., as needed

resource "azurerm_cdn_frontdoor_origin_group" "frontend" {
  name                     = "frontend-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id
  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }
  health_probe {
    interval_in_seconds = 120
    path                = "/"
    protocol            = "Https"
    request_type        = "GET"
  }
  session_affinity_enabled = false
}

resource "azurerm_cdn_frontdoor_origin" "frontend" {
  name                           = "frontend-origin"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.frontend.id
  host_name                      = var.frontend_app_hostname
  http_port                      = 80
  https_port                     = 443
  enabled                        = true
  origin_host_header             = var.frontend_app_hostname
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_origin_group" "storage" {
  name                     = "storage-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id
  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }
  health_probe {
    interval_in_seconds = 120
    path                = "/"
    protocol            = "Https"
    request_type        = "GET"
  }
  session_affinity_enabled = false
}

resource "azurerm_cdn_frontdoor_origin" "storage" {
  name                           = "storage-origin"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.storage.id
  host_name                      = var.storage_account_hostname
  http_port                      = 80
  https_port                     = 443
  enabled                        = true
  origin_host_header             = var.storage_account_hostname
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "web" {
  name                          = "web-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.afd.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.frontend.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.frontend.id]
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "MatchRequest"
  cache {
    query_string_caching_behavior = "IgnoreQueryString"
    compression_enabled           = true
    content_types_to_compress     = ["text/html", "application/javascript", "text/css", "application/json"]
  }
  enabled = true
}

resource "azurerm_cdn_frontdoor_route" "videos" {
  name                          = "videos-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.afd.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.storage.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.storage.id]
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/videos/*"]
  forwarding_protocol           = "MatchRequest"
  cache {
    query_string_caching_behavior = "IgnoreQueryString"
    compression_enabled           = false
  }
  enabled = true
}

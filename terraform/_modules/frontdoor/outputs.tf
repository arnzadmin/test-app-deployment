output "frontdoor_profile_id" {
  description = "The ID of the Front Door profile."
  value       = azurerm_cdn_frontdoor_profile.afd.id
}

output "frontdoor_endpoint_id" {
  description = "The ID of the Front Door endpoint."
  value       = azurerm_cdn_frontdoor_endpoint.afd.id
}

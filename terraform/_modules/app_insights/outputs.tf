output "instrumentation_key" {
  description = "The instrumentation key for Application Insights."
  value       = azurerm_application_insights.appi.instrumentation_key
}

output "connection_string" {
  description = "The connection string for Application Insights."
  value       = azurerm_application_insights.appi.connection_string
}

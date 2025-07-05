output "primary_connection_string" {
  description = "The primary connection string for the Storage Account."
  value       = azurerm_storage_account.st.primary_connection_string
}

output "primary_blob_endpoint_hostname" {
  description = "The hostname of the primary blob endpoint for the Storage Account."
  value       = replace(replace(azurerm_storage_account.st.primary_blob_endpoint, "https://", ""), "/", "")
}

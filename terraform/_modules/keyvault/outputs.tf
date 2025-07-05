output "vault_uri" {
  description = "The URI of the Key Vault."
  value       = azurerm_key_vault.kv.vault_uri
}

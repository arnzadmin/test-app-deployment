output "default_site_hostname" {
  description = "The default hostname of the Web App."
  value       = azurerm_linux_web_app.app.default_hostname
}

output "vnet_id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_subnets" {
  description = "The IDs of the subnets."
  value       = azurerm_subnet.snet[*].id
}

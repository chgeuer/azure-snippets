output "trigger_uri" {
  value       = lookup(azurerm_template_deployment.logicapp.outputs, "triggerURI")
  description = "The Azure Logic App trigger URL"
}


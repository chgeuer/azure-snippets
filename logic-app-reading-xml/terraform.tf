provider "azurerm" { version = "=1.40.0" }
provider "azuread" { version = "~> 0.7" }
provider "random" { version = "~> 2.2" }

resource "azurerm_resource_group" "production" {
  name     = "production-tf"
  location = var.dc_region
}

resource "azurerm_template_deployment" "example" {
  name                = var.deploymentName
  resource_group_name = azurerm_resource_group.production.name
  deployment_mode     = "Incremental"
  template_body       = file(var.armFiles.template)
  parameters = {
    "logicAppName"       = var.logicAppName
    "logicAppDefinition" = file(var.armFiles.workflowDefinition)
  }
}

output "triggerURI" {
  value = lookup(azurerm_template_deployment.example.outputs, "triggerURI")
}

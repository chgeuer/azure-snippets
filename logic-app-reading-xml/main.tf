provider "azurerm" { version = "=1.40.0" }
provider "azuread" { version = "~> 0.7" }
provider "random" { version = "~> 2.2" }

resource "azurerm_resource_group" "production" {
  name     = "production-tf"
  location = var.dc_region
}

module "logic_app" {
  source               = "./modules/logicapp"
  deployment_name      = var.deployment_name
  resource_group_name  = azurerm_resource_group.production.name
  logic_app_name       = var.logic_app_name
  logic_app_definition = file(var.workflow_definition_file)
}

output "trigger_uri" {
  value = module.logic_app.trigger_uri
}

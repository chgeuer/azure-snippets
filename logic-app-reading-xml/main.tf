provider "azurerm" { version = "=1.40.0" }
provider "azuread" { version = "~> 0.7" }
provider "random" { version = "~> 2.2" }

resource "azurerm_resource_group" "production" {
  name     = "production-tf"
  location = var.dc_region
}

module "logic_app" {
  # source             = "./modules/logicapp"
  source               = "github.com/chgeuer/azure-snippets//logic-app-reading-xml/modules/logicapp?ref=19eccf405dcdca0a1c8bd5b8a6b1af1039469414"

  resource_group_name  = azurerm_resource_group.production.name
  deployment_name      = var.deployment_name
  logic_app_name       = var.logic_app_name
  logic_app_definition = file(var.workflow_definition_file)
}

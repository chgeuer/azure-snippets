resource "azurerm_resource_group" "production" {
  name     = var.resource_group_name
  location = var.dc_region
}

module "logic_app" {
  source = "./modules/logicapp"
  #source               = "github.com/chgeuer/azure-snippets//logic-app-reading-xml/terraform/modules/logicapp?ref=master"

  resource_group_name  = azurerm_resource_group.production.name
  logic_app_name       = var.logic_app_name
  logic_app_definition = file(var.workflow_definition_file)
}

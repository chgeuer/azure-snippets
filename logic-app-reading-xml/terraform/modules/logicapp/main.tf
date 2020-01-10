locals {
  arm_template_file = "${path.module}/armtemplate.json"
}

resource "azurerm_template_deployment" "logicapp" {
  name                = "deployment-${formatdate("YYYY-MM-DD--hh-mm-ss", timestamp())}"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  template_body       = file(local.arm_template_file)
  parameters = {
    "logicAppName"       = var.logic_app_name
    "logicAppDefinition" = var.logic_app_definition
  }
}

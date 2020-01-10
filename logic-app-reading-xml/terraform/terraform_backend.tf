terraform {
  backend "azurerm" {
    resource_group_name  = "longterm"
    storage_account_name = "chgeuer"
    container_name       = "terraformstate"
    key                  = "demo2.tfstate"
  }
}
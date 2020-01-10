variable "dc_region" {
  default = "West Europe"
  type    = string
}

variable "resource_group_name" {
  type = string
}

variable "logic_app_name" {
  default = "fpp123chgeuer"
  type    = string
}

variable "deployment_name" {
  default = "deploy-logic-app-from-tf"
  type    = string
}

variable "workflow_definition_file" {
  default = "../definition.json"
  type    = string
}


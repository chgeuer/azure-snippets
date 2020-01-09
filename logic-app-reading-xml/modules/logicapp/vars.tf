variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
}

variable "logic_app_name" {
  description = "The name of the Azure Logic App"
  type        = string
}

variable "logic_app_definition" {
  description = "The JSON string of the Azure Logic App definition"
  type        = string
}

variable "deployment_name" {
  default     = "logicappdeployment"
  description = "The deployment name"
  type        = string
}


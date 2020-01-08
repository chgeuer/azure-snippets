variable "dc_region" { default = "West Europe" }
variable "logicAppName" { default = "fpp123chgeuer" }
variable "deploymentName" { default = "deploy-logic-app-from-tf" }
variable "armFiles" {
  default = {
    template           = "azuredeploy-minimal-tf.json"
    workflowDefinition = "definition.json"
  }
}

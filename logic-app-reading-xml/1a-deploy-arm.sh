#!/bin/bash 

pushd ./arm

az group create \
	--name "${resourceGroupName}" \
	--location "${location}"

# deploymentResult="$( az group deployment create \
# 	--resource-group "${resourceGroupName}" \
# 	--mode Incremental \
# 	--template-file azuredeploy.json \
# 	--parameters logicAppName="${logicAppName}" )"

deploymentResult="$( az group deployment create \
	--resource-group "${resourceGroupName}" \
	--mode Incremental \
	--template-file ./azuredeploy-minimal.json \
	--parameters logicAppName="${logicAppName}" \
	--parameters logicAppDefinition="@../definition.json" 
	)"

triggerURI="$( echo "${deploymentResult}" | jq -r ".properties.outputs.triggerURI.value" )"

popd

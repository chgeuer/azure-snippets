#!/bin/bash 

subscription="chgeuer-work"
resourceGroup="logicapptest"
logicAppName="foo1aaaxx2"

az account set --subscription "${subscription}"

az group create \
	--name "${resourceGroup}" \
	--location westeurope

# deploymentResult="$( az group deployment create \
# 	--resource-group "${resourceGroup}" \
# 	--mode Incremental \
# 	--template-file azuredeploy.json \
# 	--parameters logicAppName="${logicAppName}" )"

deploymentResult="$( az group deployment create \
	--resource-group "${resourceGroup}" \
	--mode Incremental \
	--template-file azuredeploy-minimal.json \
	--parameters \
		logicAppName="${logicAppName}" \
		logicAppDefinition="@./definition.json" )"

triggerURI="$( echo "${deploymentResult}" | jq -r ".properties.outputs.triggerURI.value" )"

# https://bagder.gitbook.io/everything-curl/usingcurl/usingcurl-verbose/usingcurl-writeout#available-write-out-variables

response="$( cat payload.xml | curl \
	--silent --include \
	--request POST \
	--url "${triggerURI}" \
	--header "Content-Type: application/xml" \
	--data @- )"

echo "${response}" | awk -v bl=1 'bl{bl=0; h=($0 ~ /HTTP\/1/)} /^\r?$/{bl=1} {print $0>(h?"header":"body")}'

defaultItemIndex="$( echo "$( cat header | grep "^X-DefaultItemIndex:" | sed -E 's/^(\S+?): (.+)/\2/' )" )"
firstElem="$( echo "$( cat header | grep "^X-FirstElem:" | sed -E 's/^(\S+?): (.+)/\2/' )" )"
body="$( cat ./body )"
rm ./body ./header

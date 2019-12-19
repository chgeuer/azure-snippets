#!/bin/bash 

subscriptionName="chgeuer-work"
az account set --subscription "${subscriptionName}"
resourceGroup="logicapptest"
logicAppName="chgeuer2"
apiVersion="2017-07-01"

subscriptionID="$( az account show --output json | jq -r ".id" )"

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
	--parameters logicAppName="${logicAppName}" \
	--parameters logicAppDefinition="@./definition.json" 
	)"

triggerURI="$( echo "${deploymentResult}" | jq -r ".properties.outputs.triggerURI.value" )"

echo "Trigger: ${triggerURI}"

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

versionId="08586248514880494834"
triggerName="manual"

#
# List workflows
#
az rest --method GET --output json --uri "https://management.azure.com/subscriptions/${subscriptionID}/resourceGroups/${resourceGroup}/providers/Microsoft.Logic/workflows?api-version=${apiVersion}"

az rest --method GET \
  --uri "https://management.azure.com/subscriptions/${subscriptionID}/resourceGroups/${resourceGroup}/providers/Microsoft.Logic/workflows/${logicAppName}/versions?api-version=${apiVersion}" \
  --query "value[].{Created:properties.createdTime,Name:name}" --output table

#
# https://docs.microsoft.com/en-us/rest/api/logic/
#
az rest --method GET --output json --uri "https://management.azure.com/subscriptions/${subscriptionID}/resourceGroups/${resourceGroup}/providers/Microsoft.Logic/workflows/${logicAppName}/versions/${versionId}?api-version=${apiVersion}"

#
# Re-fetch triggerURI
#
triggerURI="$(
  az rest --method POST --output json \
    --uri "https://management.azure.com/subscriptions/${subscriptionID}/resourceGroups/${resourceGroup}/providers/Microsoft.Logic/workflows/${logicAppName}/versions/${versionId}/triggers/${triggerName}/listCallbackUrl?api-version=${apiVersion}" \
    | jq -r ".value"
  )"

#
# List runs
#
az rest --method GET --output json \
    --uri "https://management.azure.com/subscriptions/${subscriptionID}/resourceGroups/${resourceGroup}/providers/Microsoft.Logic/workflows/${logicAppName}/runs?api-version=${apiVersion}" \
    | jq "."

#!/bin/bash 

echo "Trigger: ${triggerURI}"

# https://bagder.gitbook.io/everything-curl/usingcurl/usingcurl-verbose/usingcurl-writeout#available-write-out-variables

response="$( cat payload.xml | curl \
	--silent --include \
	--request POST \
	--url "${triggerURI}" \
	--header "Content-Type: application/xml" \
	--data @- )"

echo "${response}" | awk -v bl=1 'bl{bl=0; h=($0 ~ /HTTP\//)} /^\r?$/{bl=1} {print $0>(h?"header":"body")}'

defaultItemIndex="$( echo "$( cat header | grep -i "^X-DefaultItemIndex:" | sed -E 's/^(\S+?): (.+)/\2/' )" )"
firstElem="$( echo "$( cat header | grep -i "^X-FirstElem:" | sed -E 's/^(\S+?): (.+)/\2/' )" )"
body="$( cat ./body )"
rm ./body ./header

echo "Default Item Index: ${defaultItemIndex}"
echo "First element: ${firstElem}"

#
# List workflows
#
az rest --method GET --output json --uri "https://management.azure.com/subscriptions/${subscriptionID}/resourceGroups/${resourceGroupName}/providers/Microsoft.Logic/workflows?api-version=${apiVersion}"

#
# Query the versions
#
az rest --method GET \
  --uri "https://management.azure.com/subscriptions/${subscriptionID}/resourceGroups/${resourceGroupName}/providers/Microsoft.Logic/workflows/${logicAppName}/versions?api-version=${apiVersion}" \
  --query "value[].{Created:properties.createdTime,Name:name}" --output table

versionId="$( az rest --method GET \
    --uri "https://management.azure.com/subscriptions/${subscriptionID}/resourceGroups/${resourceGroupName}/providers/Microsoft.Logic/workflows/${logicAppName}/versions?api-version=${apiVersion}" \
    --query "value[0].name" --output json | jq -r "."
    )"
triggerName="manual"

#
# https://docs.microsoft.com/en-us/rest/api/logic/
#
az rest --method GET --output json --uri "https://management.azure.com/subscriptions/${subscriptionID}/resourceGroups/${resourceGroupName}/providers/Microsoft.Logic/workflows/${logicAppName}/versions/${versionId}?api-version=${apiVersion}"

#
# Re-fetch triggerURI
#
triggerURI="$(
  az rest --method POST --output json \
    --uri "https://management.azure.com/subscriptions/${subscriptionID}/resourceGroups/${resourceGroupName}/providers/Microsoft.Logic/workflows/${logicAppName}/versions/${versionId}/triggers/${triggerName}/listCallbackUrl?api-version=${apiVersion}" \
    | jq -r ".value"
  )"

#
# List runs
#
az rest --method GET --output json \
  --uri "https://management.azure.com/subscriptions/${subscriptionID}/resourceGroups/${resourceGroupName}/providers/Microsoft.Logic/workflows/${logicAppName}/runs?api-version=${apiVersion}" \
  | jq "."

# as table
az rest --method GET \
  --uri "https://management.azure.com/subscriptions/${subscriptionID}/resourceGroups/${resourceGroupName}/providers/Microsoft.Logic/workflows/${logicAppName}/runs?api-version=${apiVersion}" \
  --query "value[].{Start:properties.startTime,End:properties.endTime,Status:properties.response.code}" --output table

#!/bin/bash 

location="westeurope"
subscriptionName="chgeuer-work"
resourceGroupName="logicapptest123"
logicAppName="xmllogicapp"
apiVersion="2017-07-01"

az account set --subscription "${subscriptionName}"
subscriptionID="$( az account show --output json | jq -r ".id" )"

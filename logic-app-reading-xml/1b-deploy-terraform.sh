#!/bin/bash 

pushd ./terraform

plan_file="./plan"

terraform init

terraform plan \
	-var dc_region="${location}" \
	-var resource_group_name="${resourceGroupName}" \
	-var logic_app_name="${logicAppName}" \
	-var workflow_definition_file="../definition.json" \
	-out "${plan_file}"

terraform apply "${plan_file}"

rm "${plan_file}"

triggerURI="$( terraform output -json | jq -r ".trigger_uri.value" )"

popd

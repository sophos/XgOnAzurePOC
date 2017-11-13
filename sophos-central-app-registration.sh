#!/bin/bash

function update_json_role()
{
    recommended_role=$(eval echo -e '{ \"Name\": \""${ROLE_NAME}"\", \"Id\": \""${temp_role_id}"\", \"IsCustom\": true, \"Description\": \"Can read properties of virtual machines and read Activity log events.\", \"Actions\": [ \"Microsoft.Compute/virtualMachines/read\", \"Microsoft.Insights/eventtypes/values/Read\" ], \"NotActions\": [ ], \"AssignableScopes\": [ \""${subscriptions_for_role}"\" ] }')
}

function wait_for_role()
{
    for i in $(seq 1 6);
    do
        sleep 5
        echo -n "."
    done
}

az_command=$(which az)

if [ -z az ]; then
    echo "Could not find az installed."
    exit 1;
fi

app_name="Sophos Central Application"
app_list_response=$(az ad app list | jq '.[] | .appId + ";" + .displayName' | tr -d \")
if [ $? -ne 0 ]; then
    echo "Failed to list applications."
    exit 1;
fi

echo "Searching for existing ${app_name}..."
IFS=$'\n'
for each_line in ${app_list_response}
do
    IFS=';' read temp_app_id temp_app_name <<< "${each_line}"
    if [ ${temp_app_name} == ${app_name} ]; then
        app_id="${temp_app_id}"
        echo "Found existing application."
        echo
        break
    fi
done

if [ -z ${app_id} ]; then
    echo "Creating new ${app_name}..."
    echo
    app_create_response=$(az ad app create --display-name "${app_name}" --identifier-uris https://sophos-app-url-not-in-use.invalid --homepage https://sophos-app-url-not-in-use.invalid)
    if [ $? -ne 0 ]; then
        echo "Failed to create ${app_name}."
        exit 1;
    fi
    app_id=$(echo ${app_create_response} | jq '.appId' | tr -d \")
fi

sp_list_response=$(az ad sp list  | jq '.[] | .objectId + ";" + .servicePrincipalNames[0] + ";" + .servicePrincipalNames[1]' | tr -d \")
if [ $? -ne 0 ]; then
    echo "Failed to list service principals."
    exit 1;
fi

echo "Searching for existing Sophos Central Service Principal..."
IFS=$'\n'
for each_line in ${sp_list_response}
do
    IFS=';' read temp_obj_id temp_sp1 temp_sp2 <<< "${each_line}"
    if ([ ! -z ${temp_sp1} ] && [ ${temp_sp1} == ${app_id} ] || [ ! -z ${temp_sp2} ] && [ ${temp_sp2} == ${app_id} ]); then
        sp_object_id="${temp_obj_id}"
        echo "Found existing service principal for ${app_name}."
        echo
    fi
done

if [ -z ${sp_object_id} ]; then
    echo "Creating new Sophos Central Service Principal..."
    echo
    sp_create_response=$(az ad sp create --id "${app_id}")
    if [ $? -ne 0 ]; then
        echo "Failed to create Sophos Central service principal."
        exit 1;
    fi
    sp_object_id=$(echo ${sp_create_response} | jq '.objectId' | tr -d \")
fi

echo "Getting the list of all Subscriptions for Active Directory..."
subscriptions_response="$(az account list )"
if [ $? -ne 0 ]; then
    echo "Failed to list subscriptions."
    exit 1;
fi
subscriptions_for_role="/subscriptions/$(echo "${subscriptions_response}" | jq -r 'map(.id) | join("\", \"/subscriptions/")')"

echo "Found the following subscriptions: ${subscriptions_for_role}" | tr -d \"
echo

ROLE_NAME="VM Monitoring for Sophos Central"
role_list_response=$(az role definition list | jq '.[] | .properties.roleName + ";" + .name' | tr -d \")
if [ $? -ne 0 ]; then
    echo "Failed to list role definitions."
    exit 1;
fi

echo -n "Searching for existing Sophos Central role (this operation will take around 30 seconds)."

wait_for_role
echo

IFS=$'\n'
for each_line in ${role_list_response}
do
    IFS=';' read temp_role_name temp_role_id <<< "${each_line}"
    if [ ${temp_role_name} == ${ROLE_NAME} ]; then
        echo -n "Updating existing role with the recommended permissions (this operation will take around 30 seconds)."
        wait_for_role
        echo
        update_json_role
        role_response=$(az role definition update --role-definition "${recommended_role}")
        if [ $? -ne 0 ]; then
            echo "Failed to update Sophos Central role."
            exit 1;
        fi
        role_id=${temp_role_id}
        break
    fi
done

if [ -z "${role_id}" ]; then
    echo "Creating new Sophos Central role with the recommended permissions..."
    echo
    update_json_role
    role_response=$(az role definition create --role-definition "${recommended_role}")
    if [ $? -ne 0 ]; then
        echo "Failed to create Sophos Central recommended role."
        exit 1;
    fi
    role_id=$(echo ${role_response} | jq '.name' | tr -d \")
fi

subscriptions_for_role_assignment=$(echo "${subscriptions_response}" | jq '.[] | .id' | tr -d \")

echo -n "Waiting for role to propagate (this operation will take around 30 seconds)."

wait_for_role
echo
echo
echo "Searching for role assignments..."
IFS=$'\n'
for sub_id in ${subscriptions_for_role_assignment}
do
    role_assignment_id=""
    role_list_response=$(az role assignment list --scope "/subscriptions/${sub_id}" | jq '.[] | .name + ";" + .properties.principalId + ";" + .properties.roleDefinitionId' | tr -d \")
    if [ $? -ne 0 ]; then
        echo "Failed to list role assignments."
        exit 1;
    fi
    if [ ! -z "$role_list_response" ]; then
        for each_line in ${role_list_response}
        do
            IFS=';' read temp_assignment_id temp_principal_id temp_role_id <<< "${each_line}"
            if [ ${temp_principal_id} == ${sp_object_id} ] && [ ${temp_role_id} == "/subscriptions/${sub_id}/providers/Microsoft.Authorization/roleDefinitions/${role_id}" ]; then
                echo "Found existing role assignment for subscription ${sub_id}."
                role_assignment_id=${temp_assignment_id}
                break
             fi
        done
    fi
    if [ -z "$role_assignment_id" ]; then
        echo "Creating new role assignment for subscription ${sub_id}..."
        role_assignment_response=$(az role assignment create --assignee "${sp_object_id}" --role "${role_id}" --scope "/subscriptions/${sub_id}")
        if [ $? -ne 0 ]; then
            echo "Failed to create role assignment for subscription ${sub_id} with role ${role_id} and service principal ${sp_object_id}."
            exit 1;
        fi
        role_assignment_id=$(eval echo -e '"${role_assignment_response}"' | jq '.name' | tr -d \")
    fi
done

echo
echo "All done, your ${app_name} was configured for your subscriptions."
echo "Please generate a secret key for your application at the azure portal by going to the 'App Registrations' menu."
echo "For more information please refer the following KBA: https://www.sophos.com/en-us/support/knowledgebase/127184.aspx"
echo
echo "Application name: ${app_name}"
echo "Application ID: ${app_id}"
exit 0;
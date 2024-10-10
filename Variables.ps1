# Execute with "./Variables.ps1" to restore previously-saved variables.
Set-Variable -Scope Global -Name ACA_ENVIRONMENT_SUBNET_ID -Value "/subscriptions/64c3d212-40ed-4c6d-a825-6adfbdf25dad/resourceGroups/rg-tasks-tracker-mop3f6/providers/Microsoft.Network/virtualNetworks/vnet-tasks-tracker/subnets/ContainerAppSubnet"
Set-Variable -Scope Global -Name API_APP_PORT -Value 7005
Set-Variable -Scope Global -Name APPINSIGHTS_NAME -Value "appi-tasks-tracker-mop3f6"
Set-Variable -Scope Global -Name APPINSIGHTS_INSTRUMENTATIONKEY -Value "a2685249-a315-4784-a528-80ae29ee2f2b"
Set-Variable -Scope Global -Name AZURE_CONTAINER_REGISTRY_NAME -Value "crtaskstrackermop3f6"
Set-Variable -Scope Global -Name AZURE_SUBSCRIPTION_ID -Value "64c3d212-40ed-4c6d-a825-6adfbdf25dad"
Set-Variable -Scope Global -Name BACKEND_API_EXTERNAL_BASE_URL -Value "https://tasksmanager-backend-api.jollyriver-20f834af.eastus.azurecontainerapps.io"
Set-Variable -Scope Global -Name BACKEND_API_INTERNAL_BASE_URL -Value "https://tasksmanager-backend-api.internal.jollyriver-20f834af.eastus.azurecontainerapps.io"
Set-Variable -Scope Global -Name BACKEND_API_NAME -Value "tasksmanager-backend-api"
Set-Variable -Scope Global -Name BACKEND_API_PRINCIPAL_ID -Value "ed8464be-4ee4-446e-8f60-fbe69941d707"
Set-Variable -Scope Global -Name BACKEND_SERVICE_APP_PORT -Value 7204
Set-Variable -Scope Global -Name COSMOS_DB_ACCOUNT -Value "cosmos-tasks-tracker-state-store-mop3f6"
Set-Variable -Scope Global -Name COSMOS_DB_CONTAINER -Value "taskscollection"
Set-Variable -Scope Global -Name COSMOS_DB_DBNAME -Value "tasksmanagerdb"
Set-Variable -Scope Global -Name COSMOS_DB_ENDPOINT -Value "https://cosmos-tasks-tracker-state-store-mop3f6.documents.azure.com:443/"
Set-Variable -Scope Global -Name COSMOS_DB_PRIMARY_MASTER_KEY -Value "IICiyJImfZpuCfddL7KaLP9DzjSISD9SA5cSuaen9ZdFSnzGE9UOOaHw9l3JpIRqRWCxm5cpkMUEACDbykYlcw=="
Set-Variable -Scope Global -Name ENVIRONMENT -Value "cae-tasks-tracker"
Set-Variable -Scope Global -Name FRONTEND_UI_BASE_URL -Value "https://tasksmanager-frontend-webapp.jollyriver-20f834af.eastus.azurecontainerapps.io"
Set-Variable -Scope Global -Name FRONTEND_UI_BASE_URL_LOCAL -Value "https://localhost:7258"
Set-Variable -Scope Global -Name FRONTEND_WEBAPP_NAME -Value "tasksmanager-frontend-webapp"
Set-Variable -Scope Global -Name LOCATION -Value "eastus"
Set-Variable -Scope Global -Name RANDOM_STRING -Value "mop3f6"
Set-Variable -Scope Global -Name RESOURCE_GROUP -Value "rg-tasks-tracker-mop3f6"
Set-Variable -Scope Global -Name ROLE_ID -Value "00000000-0000-0000-0000-000000000002"
Set-Variable -Scope Global -Name TARGET_PORT -Value 5000
Set-Variable -Scope Global -Name UI_APP_PORT -Value 7258
Set-Variable -Scope Global -Name VNET_NAME -Value "vnet-tasks-tracker"
Set-Variable -Scope Global -Name WORKSPACE_ID -Value "c49f8aed-334c-4592-9719-74810e757138"
Set-Variable -Scope Global -Name WORKSPACE_NAME -Value "log-tasks-tracker-mop3f6"
Set-Variable -Scope Global -Name WORKSPACE_SECRET -Value "fh4KFmnlNG9vcLcgBapwAHw16MrdbuvMNXW+UXFynSa/nutcswMq1SYbJflkKGLa4VElygs6ya+sV3931dq+8w=="
Set-Variable -Scope Global -Name TODAY -Value (Get-Date -Format 'yyyyMMdd')
Write-Host "Set 31 variables."

# Execute with "./Variables.ps1" to restore previously-saved variables.
Set-Variable -Scope Global -Name ACA_ENVIRONMENT_SUBNET_ID -Value "/subscriptions/64c3d212-40ed-4c6d-a825-6adfbdf25dad/resourceGroups/rg-tasks-tracker-mop3f6/providers/Microsoft.Network/virtualNetworks/vnet-tasks-tracker/subnets/ContainerAppSubnet"
Set-Variable -Scope Global -Name APPINSIGHTS_NAME -Value "appi-tasks-tracker-mop3f6"
Set-Variable -Scope Global -Name APPINSIGHTS_INSTRUMENTATIONKEY -Value "a2685249-a315-4784-a528-80ae29ee2f2b"
Set-Variable -Scope Global -Name AZURE_CONTAINER_REGISTRY_NAME -Value "crtaskstrackermop3f6"
Set-Variable -Scope Global -Name AZURE_SUBSCRIPTION_ID -Value "64c3d212-40ed-4c6d-a825-6adfbdf25dad"
Set-Variable -Scope Global -Name BACKEND_API_EXTERNAL_BASE_URL -Value "https://tasksmanager-backend-api.jollyriver-20f834af.eastus.azurecontainerapps.io"
Set-Variable -Scope Global -Name BACKEND_API_NAME -Value "tasksmanager-backend-api"
Set-Variable -Scope Global -Name ENVIRONMENT -Value "cae-tasks-tracker"
Set-Variable -Scope Global -Name LOCATION -Value "eastus"
Set-Variable -Scope Global -Name RANDOM_STRING -Value "mop3f6"
Set-Variable -Scope Global -Name RESOURCE_GROUP -Value "rg-tasks-tracker-mop3f6"
Set-Variable -Scope Global -Name TARGET_PORT -Value 5000
Set-Variable -Scope Global -Name VNET_NAME -Value "vnet-tasks-tracker"
Set-Variable -Scope Global -Name WORKSPACE_ID -Value "c49f8aed-334c-4592-9719-74810e757138"
Set-Variable -Scope Global -Name WORKSPACE_NAME -Value "log-tasks-tracker-mop3f6"
Set-Variable -Scope Global -Name WORKSPACE_SECRET -Value "fh4KFmnlNG9vcLcgBapwAHw16MrdbuvMNXW+UXFynSa/nutcswMq1SYbJflkKGLa4VElygs6ya+sV3931dq+8w=="
Set-Variable -Scope Global -Name TODAY -Value (Get-Date -Format 'yyyyMMdd')
Write-Host "Set 17 variables."

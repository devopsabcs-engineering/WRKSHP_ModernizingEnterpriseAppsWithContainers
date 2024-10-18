# Check if Azure CLI is installed
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Output "Azure CLI is not installed. Please install it from https://aka.ms/InstallAzureCli"
    exit 1
}
else {
    Write-Output "az cli already installed"
}

# Upgrade the Azure CLI
az upgrade

# Install/upgrade the Azure Container Apps & Application Insights extensions
az extension add --upgrade --name containerapp
az extension add --upgrade --name application-insights

# Log in to Azure
az login

# Retrieve the currently active Azure subscription ID
$AZURE_SUBSCRIPTION_ID = az account show --query id --output tsv

# Set a specific Azure Subscription ID (if you have multiple subscriptions)
# $AZURE_SUBSCRIPTION_ID = "<Your Azure Subscription ID>" # Your Azure Subscription id which you can find on the Azure portal
# az account set --subscription $AZURE_SUBSCRIPTION_ID

Write-Output $AZURE_SUBSCRIPTION_ID

# create variable group
az group create `
    --name $RESOURCE_GROUP `
    --location "$LOCATION"

# create vnet
az network vnet create `
    --name $VNET_NAME `
    --resource-group $RESOURCE_GROUP `
    --address-prefix 10.0.0.0/16 `
    --subnet-name ContainerAppSubnet `
    --subnet-prefix 10.0.0.0/27

az network vnet subnet update `
    --name ContainerAppSubnet `
    --resource-group $RESOURCE_GROUP `
    --vnet-name $VNET_NAME `
    --delegations Microsoft.App/environments

$ACA_ENVIRONMENT_SUBNET_ID = $(az network vnet subnet show `
        --name ContainerAppSubnet `
        --resource-group $RESOURCE_GROUP `
        --vnet-name $VNET_NAME `
        --query id `
        --output tsv)

# Create the Log Analytics workspace
az monitor log-analytics workspace create `
    --resource-group $RESOURCE_GROUP `
    --workspace-name $WORKSPACE_NAME

# Retrieve the Log Analytics workspace ID
$WORKSPACE_ID = az monitor log-analytics workspace show `
    --resource-group $RESOURCE_GROUP `
    --workspace-name $WORKSPACE_NAME `
    --query customerId `
    --output tsv

# Retrieve the Log Analytics workspace secret
$WORKSPACE_SECRET = az monitor log-analytics workspace get-shared-keys `
    --resource-group $RESOURCE_GROUP `
    --workspace-name $WORKSPACE_NAME `
    --query primarySharedKey `
    --output tsv

# Create Application Insights instance
az monitor app-insights component create `
    --resource-group $RESOURCE_GROUP `
    --location $LOCATION `
    --app $APPINSIGHTS_NAME `
    --workspace $WORKSPACE_NAME

# Get Application Insights Instrumentation Key
$APPINSIGHTS_INSTRUMENTATIONKEY = ($(az monitor app-insights component show `
            --resource-group $RESOURCE_GROUP `
            --app $APPINSIGHTS_NAME ) | ConvertFrom-Json).instrumentationKey

az acr create `
    --name $AZURE_CONTAINER_REGISTRY_NAME `
    --resource-group $RESOURCE_GROUP `
    --sku Basic `
    --admin-enabled true

# Create the ACA environment
az containerapp env create `
    --name $ENVIRONMENT `
    --resource-group $RESOURCE_GROUP `
    --location $LOCATION `
    --logs-workspace-id $WORKSPACE_ID `
    --logs-workspace-key $WORKSPACE_SECRET `
    --dapr-instrumentation-key $APPINSIGHTS_INSTRUMENTATIONKEY `
    --enable-workload-profiles `
    --infrastructure-subnet-resource-id $ACA_ENVIRONMENT_SUBNET_ID

az acr build `
    --registry $AZURE_CONTAINER_REGISTRY_NAME `
    --image "tasksmanager/$BACKEND_API_NAME" `
    --file 'src/TasksTracker.TasksManager.Backend.Api/Dockerfile' .

$fqdn = (az containerapp create `
        --name $BACKEND_API_NAME `
        --resource-group $RESOURCE_GROUP `
        --environment $ENVIRONMENT `
        --image "$AZURE_CONTAINER_REGISTRY_NAME.azurecr.io/tasksmanager/$BACKEND_API_NAME" `
        --registry-server "$AZURE_CONTAINER_REGISTRY_NAME.azurecr.io" `
        --target-port $TARGET_PORT `
        --ingress 'external' `
        --min-replicas 1 `
        --max-replicas 1 `
        --cpu 0.25 `
        --memory 0.5Gi `
        --query properties.configuration.ingress.fqdn `
        --output tsv)

$BACKEND_API_EXTERNAL_BASE_URL = "https://$fqdn"

echo "See a listing of tasks created by the author at this URL:"
echo "https://$fqdn/api/tasks/?createdby=tjoudeh@bitoftech.net"

# frontend

az acr build `
    --registry $AZURE_CONTAINER_REGISTRY_NAME `
    --image "tasksmanager/$FRONTEND_WEBAPP_NAME" `
    --file 'src/TasksTracker.WebPortal.Frontend.Ui/Dockerfile' .

$fqdn = (az containerapp create `
        --name "$FRONTEND_WEBAPP_NAME"  `
        --resource-group $RESOURCE_GROUP `
        --environment $ENVIRONMENT `
        --image "$AZURE_CONTAINER_REGISTRY_NAME.azurecr.io/tasksmanager/$FRONTEND_WEBAPP_NAME" `
        --registry-server "$AZURE_CONTAINER_REGISTRY_NAME.azurecr.io" `
        --env-vars "BackendApiConfig__BaseUrlExternalHttp=$BACKEND_API_EXTERNAL_BASE_URL/" `
        --target-port $TARGET_PORT `
        --ingress 'external' `
        --min-replicas 1 `
        --max-replicas 1 `
        --cpu 0.25 `
        --memory 0.5Gi `
        --query properties.configuration.ingress.fqdn `
        --output tsv)

$FRONTEND_UI_BASE_URL = "https://$fqdn"

echo "See the frontend web app at this URL:"
echo $FRONTEND_UI_BASE_URL

$fqdn = (az containerapp ingress enable `
        --name $BACKEND_API_NAME  `
        --resource-group $RESOURCE_GROUP `
        --target-port $TARGET_PORT `
        --type "internal" `
        --query fqdn `
        --output tsv)

$BACKEND_API_INTERNAL_BASE_URL = "https://$fqdn"

echo "The internal backend API URL:"
echo $BACKEND_API_INTERNAL_BASE_URL

az containerapp update `
    --name "$FRONTEND_WEBAPP_NAME" `
    --resource-group $RESOURCE_GROUP `
    --set-env-vars "BackendApiConfig__BaseUrlExternalHttp=$BACKEND_API_INTERNAL_BASE_URL/"


# setting up dapr for local dev

$API_APP_PORT = 7286
$UI_APP_PORT = 7026

$FRONTEND_UI_BASE_URL_LOCAL = "https://localhost:$UI_APP_PORT"

Set-Location src/TasksTracker.TasksManager.Backend.Api

dapr run `
    --app-id tasksmanager-backend-api `
    --app-port $API_APP_PORT `
    --dapr-http-port 3500 `
    --app-ssl `
    -- dotnet run --launch-profile https

Start-Process http://localhost:3500/v1.0/invoke/tasksmanager-backend-api/method/api/tasks?createdBy=tjoudeh@bitoftech.net

./variables.ps1
cd src/TasksTracker.WebPortal.Frontend.Ui

dapr run `
    --app-id tasksmanager-frontend-webapp `
    --app-port $UI_APP_PORT `
    --dapr-http-port 3501 `
    --app-ssl `
    -- dotnet run --launch-profile https

./variables.ps1
cd src/TasksTracker.TasksManager.Backend.Api

dapr run `
    --app-id tasksmanager-backend-api `
    --app-port $API_APP_PORT `
    --dapr-http-port 3500 `
    --app-ssl `
    -- dotnet run --launch-profile https

# fix the launch.json and tasks.json

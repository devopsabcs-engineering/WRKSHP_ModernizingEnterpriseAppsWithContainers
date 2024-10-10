$RESOURCE_GROUP = "rg-aca-workshop-003"
$LOCATION = "eastus2"

Write-Output "Creating Resource Group $RESOURCE_GROUP in $LOCATION"
az group create `
    --name $RESOURCE_GROUP `
    --location $LOCATION

$CONTAINER_REGISTRY_NAME = "cracaworkshopek002"

Write-Output "Creating Azure Container Registry $CONTAINER_REGISTRY_NAME in $RESOURCE_GROUP"
az acr create `
    --resource-group $RESOURCE_GROUP `
    --name $CONTAINER_REGISTRY_NAME `
    --sku Basic

## Build Backend API on ACR and Push to ACR
Write-Output "Building Backend API on ACR and Push to ACR"
az acr build --registry $CONTAINER_REGISTRY_NAME `
    --image "tasksmanager/tasksmanager-backend-api" `
    --file 'src/TasksTracker.TasksManager.Backend.Api/Dockerfile' .

## Build Backend Service on ACR and Push to ACR
Write-Output "Building Backend Service on ACR and Push to ACR"
az acr build --registry $CONTAINER_REGISTRY_NAME `
    --image "tasksmanager/tasksmanager-backend-processor" `
    --file 'src/TasksTracker.Processor.Backend.Svc/Dockerfile' .

## Build Frontend Web App on ACR and Push to ACR
Write-Output "Building Frontend Web App on ACR and Push to ACR"
az acr build --registry $CONTAINER_REGISTRY_NAME `
    --image "tasksmanager/tasksmanager-frontend-webapp" `
    --file 'src/TasksTracker.WebPortal.Frontend.Ui/Dockerfile' .

Write-Output "Creating Container App Service Plan"
az deployment group create `
    --resource-group $RESOURCE_GROUP `
    --template-file "infra/bicep/main.bicep" `
    --parameters "infra/bicep/main.parameters.json"
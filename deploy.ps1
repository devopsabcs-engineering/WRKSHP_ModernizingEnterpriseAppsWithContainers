param (
    [Parameter()]
    [string] $InstanceName = "005"
)

$RESOURCE_GROUP = "rg-aca-workshop-$InstanceName"
$LOCATION = "eastus2"
$addCosmosDbRole = $false # Add Cosmos DB Role - for INTERACTIVE LOGIN ONLY

Write-Output "Creating Resource Group $RESOURCE_GROUP in $LOCATION"
az group create `
    --name $RESOURCE_GROUP `
    --location $LOCATION

# Get Unique String for Resource Group
$uniqueString = az group show --name $RESOURCE_GROUP --query id -o tsv | .\ArmUniqueStringGenerator.ps1
Write-Output "Unique String: $uniqueString"

$CONTAINER_REGISTRY_NAME = "cr$uniqueString"

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

# read main.parameters.template.json file and update the container registry name
$parameters = Get-Content "infra/bicep/main.parameters.template.json" -Raw
$parameters = $parameters -replace "__CONTAINER_REGISTRY_NAME__", $CONTAINER_REGISTRY_NAME
$parameters | Set-Content "infra/bicep/main.parameters-$InstanceName.json"

Write-Output "Parameters file updated with Container Registry Name"
Get-Content "infra/bicep/main.parameters-$InstanceName.json"

Write-Output "Creating Container App Service Plan"
az deployment group create `
    --resource-group $RESOURCE_GROUP `
    --template-file "infra/bicep/main.bicep" `
    --parameters "infra/bicep/main.parameters-$InstanceName.json"

Write-Output "Deployment Completed"

if ($addCosmosDbRole) {
    # Add Cosmos DB Role - for INTERACTIVE LOGIN ONLY
    Write-Output "Adding Cosmos DB Role"
    # get output of the deployment from cosmos db
    $COSMOS_DB_ACCOUNT = az deployment group show --resource-group $RESOURCE_GROUP `
        --name main --query properties.outputs.cosmosDbAccountName.value -o tsv

    Write-Output "Cosmos DB Account: $COSMOS_DB_ACCOUNT"

    $ROLE_ID = "00000000-0000-0000-0000-000000000002" #"Cosmos DB Built-in Data Contributor" 

    # get the principal id for current user
    $principalId = $(az ad signed-in-user show --query id -o tsv)
    Write-Output "Principal Id: $principalId"

    Write-Output "Setting Cosmos DB Role"
    az cosmosdb sql role assignment create `
        --resource-group $RESOURCE_GROUP `
        --account-name  $COSMOS_DB_ACCOUNT `
        --scope "/" `
        --principal-id $principalId `
        --role-definition-id $ROLE_ID
}
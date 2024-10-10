$ROLE_ID = "00000000-0000-0000-0000-000000000002" #"Cosmos DB Built-in Data Contributor" 

./Variables.ps1

# get the principal id for current user
$principalId = $(az ad signed-in-user show --query id -o tsv)
Write-Output "Principal Id: $principalId"

az cosmosdb sql role assignment create `
    --resource-group $RESOURCE_GROUP `
    --account-name  $COSMOS_DB_ACCOUNT `
    --scope "/" `
    --principal-id $principalId `
    --role-definition-id $ROLE_ID

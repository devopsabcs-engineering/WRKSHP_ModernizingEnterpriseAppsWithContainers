$COSMOS_DB_ACCOUNT="cosmos-tasks-tracker-state-store-$RANDOM_STRING"
$COSMOS_DB_DBNAME="tasksmanagerdb"
$COSMOS_DB_CONTAINER="taskscollection" 

# Check if Cosmos account name already exists globally
$result = az cosmosdb check-name-exists `
--name $COSMOS_DB_ACCOUNT

# Continue if the Cosmos DB account does not yet exist
if ($result -eq "false") {
    echo "Creating Cosmos DB account..."

    # Create a Cosmos account for SQL API
    az cosmosdb create `
    --name $COSMOS_DB_ACCOUNT `
    --resource-group $RESOURCE_GROUP

    # Create a SQL API database
    az cosmosdb sql database create `
    --name $COSMOS_DB_DBNAME `
    --resource-group $RESOURCE_GROUP `
    --account-name $COSMOS_DB_ACCOUNT

    # Create a SQL API container
    az cosmosdb sql container create `
    --name $COSMOS_DB_CONTAINER `
    --resource-group $RESOURCE_GROUP `
    --account-name $COSMOS_DB_ACCOUNT `
    --database-name $COSMOS_DB_DBNAME `
    --partition-key-path "/id" `
    --throughput 400

    $COSMOS_DB_ENDPOINT=(az cosmosdb show `
    --name $COSMOS_DB_ACCOUNT `
    --resource-group $RESOURCE_GROUP `
    --query documentEndpoint `
    --output tsv)

    echo "Cosmos DB Endpoint: "
    echo $COSMOS_DB_ENDPOINT
}
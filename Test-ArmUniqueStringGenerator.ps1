$RESOURCE_GROUP = "rg-aca-workshop-003"

Write-Output "---------------------------------------------------"

$expected = "vgcxhwvqqm7my"
# Pass an ordinary string
$actual = .\ArmUniqueStringGenerator.ps1 -InputStringValue "test example"

Write-Output "Expected: $expected"
Write-Output "Actual: $actual"

# assert they are equal
if ($expected -eq $actual) {
    Write-Output "Test Passed"
}
else {
    Write-Output "Test Failed"
}

Write-Output "---------------------------------------------------"
Write-Output "---------------------------------------------------"

# Get Resource group name and pass the id to unique string generator.
$actual = az group show --name $RESOURCE_GROUP --query id -o tsv
$expected = "/subscriptions/64c3d212-40ed-4c6d-a825-6adfbdf25dad/resourceGroups/rg-aca-workshop-003"
$resourceGroupId = $expected

Write-Output "Resource Group Id (expected): $expected"
Write-Output "Resource Group Id (actual): $actual"

# assert they are equal
if ($expected -eq $actual) {
    Write-Output "Test Passed"
}
else {
    Write-Output "Test Failed"
}

Write-Output "---------------------------------------------------"
Write-Output "---------------------------------------------------"

# Pass the resource group id to unique string generator.
$expected = "vmgxilmjykyoy"
Write-Output "Unique String: "
$actual = $resourceGroupId | .\ArmUniqueStringGenerator.ps1

Write-Output "Expected: $expected"
Write-Output "Actual: $actual"

# assert they are equal
if ($expected -eq $actual) {
    Write-Output "Test Passed"
}
else {
    Write-Output "Test Failed"
}

Write-Output "---------------------------------------------------"


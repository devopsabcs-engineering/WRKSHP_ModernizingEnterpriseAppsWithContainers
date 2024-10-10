# do a call to http://localhost:3500/v1.0/publish/taskspubsub/tasksavedtopic
# with body
# {
#     "taskId": "fbc55b2c-d9fa-405e-aec8-22e53f4306dd",
#     "taskName": "Testing Pub Sub Publisher",
#     "taskCreatedBy": "user@mail.net",
#     "taskCreatedOn": "2023-02-12T00:24:37.7361348Z",
#     "taskDueDate": "2023-02-20T00:00:00",
#     "taskAssignedTo": "user2@mail.com"
# }
$jsonDepth = 100
$uri = "http://localhost:3500/v1.0/publish/taskspubsub/tasksavedtopic"
$headers = @{"Content-Type" = "application/json" }
$body = @{
    taskId         = "fbc55b2c-d9fa-405e-aec8-22e53f4306dd"
    taskName       = "Testing Pub Sub Publisher"
    taskCreatedBy  = "user@mail.net"
    taskCreatedOn  = "2023-02-12T00:24:37.7361348Z"
    taskDueDate    = "2023-02-20T00:00:00"
    taskAssignedTo = "user2@mail.com"
}

$bodyJson = $body | ConvertTo-Json -Depth $jsonDepth
$response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $bodyJson
$response
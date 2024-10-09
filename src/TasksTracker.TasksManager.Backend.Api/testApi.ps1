# do the following api call:
# POST /v1.0/state/statestore HTTP/1.1
# Host: localhost:3500
# Content-Type: application/json
# [
#     {
#         "key": "Book1",
#         "value": {
#             "title": "Parallel and High Performance Computing",
#             "author": "Robert Robey",
#             "genre": "Technical"
#         }
#     },
#     {
#         "key": "Book2",
#         "value": {
#             "title": "Software Engineering Best Practices",
#             "author": "Capers Jones",
#             "genre": "Technical"
#         }
#     },
#     {
#         "key": "Book3",
#         "value": {
#             "title": "The Unstoppable Mindset",
#             "author": "Jessica Marks",
#             "genre": "Self Improvement",
#             "formats":["kindle", "audiobook", "papercover"]
#         }
#     }
# ]

$jsonDepth = 100

$uri = "http://localhost:3500/v1.0/state/statestore"
$headers = @{"Content-Type" = "application/json"}
$body = @(
    @{
        key = "Book1"
        value = @{
            title = "Parallel and High Performance Computing"
            author = "Robert Robey"
            genre = "Technical"
        }
    },
    @{
        key = "Book2"
        value = @{
            title = "Software Engineering Best Practices"
            author = "Capers Jones"
            genre = "Technical"
        }
    },
    @{
        key = "Book3"
        value = @{
            title = "The Unstoppable Mindset"
            author = "Jessica Marks"
            genre = "Self Improvement"
            formats = @("kindle", "audiobook", "papercover")
        }
    }
)

$response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body ($body | ConvertTo-Json -Depth $jsonDepth)

# Output the response
$response

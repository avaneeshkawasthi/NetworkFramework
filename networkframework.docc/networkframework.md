# ``networkframework``

A lightweight Swift networking framework providing a unified API for making HTTP requests using Combine, async/await, or completion handlers.

## Overview
`NetworkService` is the main entry point. It provides three ways to make requests:
- Combine publisher
- Async/await
- Completion handler

All methods use the `APIServiceError` enum for error handling.

## Topics
### NetworkService
- ``NetworkService/init()``
- ``NetworkService/sendRequest(endpoint:type:)``
- ``NetworkService/sendRequest(endpoint:)``
- ``NetworkService/sendRequest(endpoint:resultHandler:)``

### Error Handling
- ``APIServiceError``

## Example
```swift
let service = NetworkService()
// Combine
service.sendRequest(endpoint: myEndpoint, type: MyModel.self)
// Async/await
let result: MyModel = try await service.sendRequest(endpoint: myEndpoint)
// Completion handler
service.sendRequest(endpoint: myEndpoint) { (result: Result<MyModel, APIServiceError>) in ... }
```

---

For more details, see the README.md.

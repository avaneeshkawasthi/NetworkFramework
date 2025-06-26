# networkframework

A lightweight Swift networking framework providing a unified API for making HTTP requests using Combine, async/await, or completion handlers.

## Features
- Combine publisher-based requests
- Async/await requests
- Completion handler requests
- Unified error handling with `APIServiceError`

## Usage

### Combine Example
```swift
let service = NetworkService()
service.sendRequest(endpoint: myEndpoint, type: MyModel.self)
    .sink(receiveCompletion: { completion in
        // handle error or finished
    }, receiveValue: { value in
        // handle value
    })
    .store(in: &cancellables)
```

### Async/Await Example
```swift
let service = NetworkService()
do {
    let result: MyModel = try await service.sendRequest(endpoint: myEndpoint)
    // handle result
} catch {
    // handle error
}
```

### Completion Handler Example
```swift
let service = NetworkService()
service.sendRequest(endpoint: myEndpoint) { (result: Result<MyModel, APIServiceError>) in
    switch result {
    case .success(let value):
        // handle value
    case .failure(let error):
        // handle error
    }
}
```

## Documentation
See the [networkframework.docc/networkframework.md](networkframework.docc/networkframework.md) for full API documentation.

## Packaging
- To use as a Swift Package, add this repo as a dependency in Xcode or your `Package.swift`:

```swift
.package(url: "https://github.com/avaneeshkawasthi/NetworkFramework.git", from: "1.0.0")
```

- To use as an XCFramework, archive the framework in Xcode and distribute the generated `.xcframework`.

## Further Improvements
- Add more request customization (headers, body, etc.)
- Add support for multipart/form-data
- Add request/response logging
- Add unit tests

## 🛠️ Installation
Add NetworkKit to your project using Swift Package Manager: [Project URL](https://github.com/yourusername/networkframework)

## 🤝 Contributions
Have ideas or improvements? Feel free to submit issues or pull requests to help enhance NetworkKit.

## 🔗 Connect with Me
Stay updated on the latest features and releases by following me on [LinkedIn](https://www.linkedin.com/in/avaneesh-awasthi-10747659/)

---

© 2025 MIT License.

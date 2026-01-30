# swiftui-pager

A simple SwiftUI pager component that provides tab navigation with swipeable pages and a highlight indicator.

## Requirements

- Swift 6.2+
- iOS, macOS, tvOS, watchOS, visionOS

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/0x1-company/swiftui-pager", from: "1.0.0")
]
```

Then add `Pager` to your target dependencies:

```swift
.target(
    name: "YourApp",
    dependencies: ["Pager"]
)
```

## Usage

```swift
import Pager

PagerView {
  Page {
    Text("Home")
  } label: {
    Text("Home")
  }

  Page {
    Text("Search")
  } label: {
    Text("Search")
  }

  Page {
    Text("Account")
  } label: {
    Text("Account")
  }
}
```

## License

MIT

# swiftui-pager

A simple SwiftUI pager component that provides tab navigation with swipeable pages and a highlight indicator.

## Requirements

- Swift 6.2+
- iOS, tvOS, watchOS, visionOS

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

## Custom Selection Type

`PagerView` supports a generic `Selection` type, allowing you to use a custom `Hashable` enum instead of the default `Int` index. Pass a `Binding<Selection>` to track and control the selected page.

```swift
import Pager

enum Tab: Hashable {
  case home, search, account
}

struct ContentView: View {
  @State private var selectedTab: Tab = .home

  var body: some View {
    PagerView(selection: $selectedTab) {
      Page(id: Tab.home) {
        Text("Home Content")
      } label: {
        Text("Home")
      }

      Page(id: Tab.search) {
        Text("Search Content")
      } label: {
        Text("Search")
      }

      Page(id: Tab.account) {
        Text("Account Content")
      } label: {
        Text("Account")
      }
    }
  }
}
```

## License

MIT

// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "swiftui-pager",
  products: [
    .library(name: "Pager", targets: ["Pager"]),
  ],
  targets: [
    .target(name: "Pager"),
  ]
)

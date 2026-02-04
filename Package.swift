// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "swiftui-pager",
  platforms: [
    SupportedPlatform.iOS(SupportedPlatform.IOSVersion.v18),
    SupportedPlatform.macOS(SupportedPlatform.MacOSVersion.v15),
  ],
  products: [
    .library(name: "Pager", targets: ["Pager"]),
  ],
  targets: [
    .target(name: "Pager"),
  ]
)

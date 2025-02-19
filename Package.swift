// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "firebaseanalytics-swift",
  platforms: [
    .macOS(.v14),
    .iOS(.v17),
  ],
  products: [
    .library(
      name: "Analytics",
      targets: ["Analytics"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-http-types", from: "1.3.0"),
    .package(url: "https://github.com/zunda-pixel/http-client", from: "0.3.0"),
    .package(url: "https://github.com/OpenSwiftUIProject/ProtobufKit", from: "0.1.2"),
    .package(url: "https://github.com/zunda-pixel/swift-currency", from: "0.0.1"),
  ],
  targets: [
    .target(
      name: "Analytics",
      dependencies: [
        .product(name: "Currency", package: "swift-currency"),
        .product(name: "ProtobufKit", package: "ProtobufKit"),
        .product(name: "HTTPClient", package: "http-client"),
        .product(name: "HTTPTypes", package: "swift-http-types"),
      ]
    ),
    .testTarget(
      name: "AnalyticsTests",
      dependencies: [
        .target(name: "Analytics"),
        .product(name: "HTTPTypesFoundation", package: "swift-http-types"),
      ]
    ),
  ]
)

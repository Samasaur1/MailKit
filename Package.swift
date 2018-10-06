// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "MailKit",
    products: [
        .library(name: "MailKit", targets: ["MailKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Samasaur1/ProtocolKit.git", from: "1.0.2"),
    ],
    targets: [
        .target(name: "MailKit", dependencies: ["ProtocolKit"]),
        .testTarget(name: "MailKitTests", dependencies: ["MailKit"]),
    ]
)

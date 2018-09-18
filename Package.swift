// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "MailKit",
    products: [
        .library(name: "MailKit", targets: ["MailKit"]),
    ],
    targets: [
        .target(name: "MailKit", dependencies: []),
        .testTarget(name: "MailKitTests", dependencies: ["MailKit"]),
    ]
)

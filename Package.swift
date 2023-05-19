// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftCustoms",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "SwiftCustoms", targets: ["SwiftCustoms"]),
        .library(name: "CustomFirebase", targets: ["CustomFirebase"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: Version("8.7.0")),
        .package(url: "https://github.com/exyte/ActivityIndicatorView.git", from: Version("1.1.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CustomFirebase",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk")
            ],
            path: "Firebase"
        ),
        .target(
            name: "SwiftCustoms",
            dependencies: [
                .product(name: "ActivityIndicatorView", package: "activityindicatorview")
            ],
            path: "Views"
        ),
        .testTarget(
            name: "SwiftCustomsTests",
            dependencies: ["SwiftCustoms"]),
    ]
)

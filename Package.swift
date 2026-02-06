// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "FromMe",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .executable(name: "FromMeApp", targets: ["FromMeApp"])
    ],
    targets: [
        .executableTarget(
            name: "FromMeApp",
            path: "Sources/FromMeApp"
        )
    ]
)

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PrompIT",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "PrompIT", targets: ["PrompIT"])
    ],
    targets: [
        .executableTarget(
            name: "PrompIT",
            path: "Sources/PrompIT"
        )
    ]
)

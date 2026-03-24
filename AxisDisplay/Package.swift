// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AxisDisplay",
    platforms: [
        .iOS(.v16)
    ],
    targets: [
        .executableTarget(
            name: "AxisDisplay",
            path: "Sources/AxisDisplay"
        )
    ]
)

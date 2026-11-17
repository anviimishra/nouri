// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "NouriKit",
    platforms: [.iOS(.v17), .watchOS(.v10), .macOS(.v14)],
    products: [
        .library(name: "NouriKit", targets: ["NouriKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "NouriKit",
            dependencies: [.product(name: "Supabase", package: "supabase-swift")]
        ),
        .testTarget(name: "NouriKitTests", dependencies: ["NouriKit"]),
    ]
)

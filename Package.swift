// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BerTlv",
    products: [
        .library(name: "BerTlv", targets: ["BerTlv"])
    ],
    targets: [
        .target(name: "BerTlv", path: "BerTlv", exclude: ["BerTlv-Prefix.pch"])
    ]
)

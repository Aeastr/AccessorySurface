// swift-tools-version: 6.0
// Copyright (c) 2026 Aether.
// SPDX-License-Identifier: MIT

import PackageDescription

let package = Package(
    name: "AccessorySurface",
    platforms: [.iOS("26.0")],
    products: [.library(name: "AccessorySurface", targets: ["AccessorySurface"])],
    targets: [
        .target(name: "AccessoryRuntime", publicHeadersPath: "include"),
        .target(name: "AccessorySurface", dependencies: ["AccessoryRuntime"])
    ]
)

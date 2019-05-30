// swift-tools-version:5.0
//
//  Package.swift
//  Relay
//
//  Created by John Hammerlund on 10/11/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "Relay",
    platforms: [
        .macOS(.v10_11),
        .iOS(.v8),
        .tvOS(.v9),
        .watchOS(.v2),
    ],
    products: [
        .library(
            name: "Relay",
            targets: ["Relay"])
        ],
    dependencies: [],
    targets: [
        .target(
            name: "Relay",
            dependencies: []),
        .testTarget(
            name: "RelayTests",
            dependencies: ["Relay"])
        ]
)

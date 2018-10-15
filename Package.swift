// swift-tools-version:4.2
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

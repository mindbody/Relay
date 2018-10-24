//
//  DynamicDependencyRegistry.swift
//  Relay
//
//  Created by John Hammerlund on 9/17/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// Registers dynamic dependencies
///
/// - Note: Unresolved or mismatched types/factories will cause a crash
public final class DynamicDependencyRegistry: DependencyRegistryType {

    private let index: DynamicDependencyIndex
    private let metaContainers: [DependencyMetaContainer]

    /// Creates a DynamicDependencyRegistry
    ///
    /// - Parameter metaContainers: A list of container metatypes used to resolve
    ///   real types, factories, and DependencyContainers
    public init(index: DynamicDependencyIndex = .shared, metaContainers: [DependencyMetaContainer]) {
        self.index = index
        self.metaContainers = metaContainers
    }

    public func registerDependencies() throws {
        /// Custom dependencies will override defaults
        for metaContainer in metaContainers {
            let container = DependencyContainer.container(for: metaContainer.scope)
            for definition in metaContainer.definitions {
                let type = try index.lookup(type: definition.typeIdentifier)
                let factory = try index.lookup(factory: definition.factoryIdentifier)

                container.register(key: DependencyKey(type), lifecycle: definition.lifecycle, with: factory)
            }
        }

        debugPrint(containers: metaContainers)
    }

    private func debugPrint(containers: [DependencyMetaContainer]) {
        print("Dynamic Dependency Registration Details\n=====================================")
        for container in containers {
            print("Scope: \(container.scope.value) {")
            for definition in container.definitions {
                print("\t\(definition.typeIdentifier.tag) => \(definition.factoryIdentifier.tag)")
            }
            print("}")
        }
        print("=====================================")
    }

}

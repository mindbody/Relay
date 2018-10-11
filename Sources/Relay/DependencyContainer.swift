//
//  DependencyContainer.swift
//  Relay
//
//  Created by John Hammerlund on 9/10/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// An IoC container used to resolve abstract dependencies
public final class DependencyContainer {

    private static var containers: [DependencyContainerScope: DependencyContainer] = [:]
    private static let queue = DispatchQueue(label: "com.mindbodyonline.Relay.DependencyContainer")

    /// The default DependencyContainer with global scope
    public static var global: DependencyContainer = {
        container(for: .global)
    }()

    private var factories: [DependencyKey: (DependencyContainer) -> Any] = [:]
    private var dependencies: [DependencyKey: Any] = [:]

    /// Returns a DependencyContainer with given scope. If unavailable, then a new one is created.
    ///
    /// - Parameter componentScope: The scope of injection
    /// - Returns: A DependencyContainer
    public static func container(for componentScope: DependencyContainerScope) -> DependencyContainer {
        var container: DependencyContainer!
        queue.sync {
            if let existingContainer = DependencyContainer.containers[componentScope] {
                container = existingContainer
            }
            else {
                container = DependencyContainer()
                DependencyContainer.containers[componentScope] = container
            }
        }
        return container
    }

    private func keyFor<T>(_ type: T.Type = T.self) -> DependencyKey {
        return DependencyKey(type)
    }

    /// Registers a concrete type for an abstract dependency
    ///
    /// - Parameters:
    ///   - type: The abstract dependency
    ///   - factory: The concrete factory for dependency resolution, executed once and only once
    public func register<T>(_ type: T.Type = T.self, with factory: @escaping (DependencyContainer) -> T) {
        let key = keyFor(type)
        register(key: key, with: factory)
    }

    /// Registers a dynamic factory for an abstract dependency
    ///
    /// - Parameters:
    ///   - key: A key used to uniquely identify an injected dependency
    ///   - factory: The dynamic factory for dependency resolution, executed once and only once
    public func register(key: DependencyKey, with factory: @escaping (DependencyContainer) -> Any) {
        dependencies[key] = nil
        factories[key] = factory
    }

    /// Resolves a concrete type from an abstract dependency
    ///
    /// - Parameter dependencyType: The abstract dependency
    /// - Returns: A concrete implementor
    public func resolve<T>(_ dependencyType: T.Type = T.self) -> T {
        let key = keyFor(dependencyType)
        if let resolved = dependencies[key] as? T {
            return resolved
        }
        guard let found = factories[keyFor(dependencyType)]?(self) else {
            if self === DependencyContainer.global {
                fatalError("Failed to resolve dependency for '\(dependencyType)'")
            }
            return DependencyContainer.global.resolve(dependencyType)
        }
        guard let resolved = found as? T else {
            fatalError("Dependency mismatch; expected type \"\(T.self)\", got \"\(type(of: found))\"")
        }
        dependencies[key] = resolved
        return resolved
    }

}

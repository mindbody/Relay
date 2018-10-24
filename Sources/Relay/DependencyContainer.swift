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
    private static let queue = DispatchQueue(label: "com.mindbodyonline.Relay.DependencyContainer.static")

    /// The default DependencyContainer with global scope
    public static var global: DependencyContainer = {
        container(for: .global)
    }()

    private var factories: [DependencyKey: (DependencyContainer) -> Any] = [:]
    private var singletonDependencies: [DependencyKey: Any] = [:]
    private var lifecycles: [DependencyKey: LifecycleType] = [:]
    private var instanceQueue = DispatchQueue(label: "com.mindbodyonline.Relay.DependencyContainer.static")

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
    ///   - lifecycle: Determines the dependency lifetime. Defaults to `.singleton`
    ///   - factory: The concrete factory for dependency resolution, executed once and only once
    public func register<T>(_ type: T.Type = T.self, lifecycle: LifecycleType = .singleton, with factory: @escaping (DependencyContainer) -> T) {
        let key = keyFor(type)
        register(key: key, lifecycle: lifecycle, with: factory)
    }

    /// Registers a dynamic factory for an abstract dependency
    ///
    /// - Parameters:
    ///   - key: A key used to uniquely identify an injected dependency
    ///   - lifecycle: Determines the dependency lifetime. Defaults to `.singleton`
    ///   - factory: The dynamic factory for dependency resolution, executed once and only once
    public func register(key: DependencyKey, lifecycle: LifecycleType = .singleton, with factory: @escaping (DependencyContainer) -> Any) {
        instanceQueue.sync {
            singletonDependencies[key] = nil
            lifecycles[key] = lifecycle
            factories[key] = factory
        }
    }

    /// Resolves a concrete type from an abstract dependency
    ///
    /// - Parameter dependencyType: The abstract dependency
    /// - Returns: A concrete implementor
    public func resolve<T>(_ dependencyType: T.Type = T.self) -> T {
        let key = keyFor(dependencyType)
        let lifecycle = lifecycles[key] ?? .singleton

        if lifecycle == .singleton, let resolved = singletonDependencies[key] as? T {
            return resolved
        }
        guard let found = factories[keyFor(dependencyType)]?(self) else {
            if lifecycle == .transient || self === DependencyContainer.global {
                fatalError("Failed to resolve dependency for '\(dependencyType)'")
            }
            return DependencyContainer.global.resolve(dependencyType)
        }
        guard let resolved = found as? T else {
            fatalError("Dependency mismatch; expected type \"\(T.self)\", got \"\(type(of: found))\"")
        }
        singletonDependencies[key] = resolved
        return resolved
    }

}

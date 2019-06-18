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
    private var resolutionDispatchGroups: [DependencyKey: DispatchGroup] = [:]

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
        let baseType = T?.underlyingType
        return DependencyKey(baseType)
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

    /// Registers a dynamic factory for an abstract dependency. Can be safely called from multiple threads.
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

    /// Resolves a concrete type from an abstract dependency. Can be safely called from multiple threads.
    ///
    /// - Parameter dependencyType: The abstract dependency
    /// - Returns: A concrete implementor
    public func resolve<T>(_ dependencyType: T.Type = T.self) -> T {
        /// This function must be thread-safe to avoid re-executing any factory for a given dependency.
        /// Since factories could involve recursive resolution, we must manage the various running operations ourselves.
        ///
        /// We do this by registering a DispatchGroup when we know that the factory will have to be used for a given type.
        /// These groups are serially type-mapped. If a group already exists, then we wait for it to complete before recursing;
        /// otherwise, we continue to executing the mapped factory.
        ///
        /// For transient dependencies, this means that the threads will execute the factory in FIFO order.

        let key = keyFor(dependencyType)
        let lifecycle = instanceQueue.sync { lifecycles[key] ?? .singleton }

        let existingDependency = instanceQueue.sync { () -> T? in
            if lifecycle == .singleton, singletonDependencies[key] != nil, let resolved = singletonDependencies[key] as? T {
                return resolved
            }
            return nil
        }
        if let existingDependency = existingDependency {
            return existingDependency
        }

        /// If a group already exists, then we'll wait for it to complete on the separate thread
        var isResolutionActive: Bool = false
        let dispatchGroup = instanceQueue.sync { () -> DispatchGroup in
            if let group = resolutionDispatchGroups[key] {
                isResolutionActive = true
                return group
            }
            let group = DispatchGroup()
            resolutionDispatchGroups[key] = group
            return group
        }
        if isResolutionActive {
            dispatchGroup.wait()
            return resolve(dependencyType)
        }

        /// We're the first one in & must notify the group once we've executed the factory
        dispatchGroup.enter()
        defer {
            instanceQueue.sync {
                resolutionDispatchGroups[key] = nil
            }
            dispatchGroup.leave()
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
        instanceQueue.sync {
            singletonDependencies[key] = resolved
        }
        return resolved
    }

}

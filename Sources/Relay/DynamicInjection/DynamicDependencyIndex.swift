//
//  DynamicDependencyIndex.swift
//  Relay
//
//  Created by John Hammerlund on 9/17/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

public enum DynamicDependencyIndexError: Error {
    case typeNotFound(identifier: String)
    case factoryNotFound(identifier: String)

    public var errorDescription: String? {
        switch self {
        case let .typeNotFound(identifier):
            return "Type index not found for \"\(identifier)\""
        case let .factoryNotFound(identifier):
            return "Factory index not found for \"\(identifier)\""
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case let .typeNotFound(identifier):
            return "Ensure that the registry's DynamicDependencyIndex has indexed a type for identifier \"\(identifier)\""
        case let .factoryNotFound(identifier):
            return "Ensure that the registry's DynamicDependencyIndex has indexed a factory for identifier \"\(identifier)\""
        }
    }
}

/// Indexes all abstract types and concrete factories for dynamic dependency injection
public final class DynamicDependencyIndex {

    public static let shared = DynamicDependencyIndex()

    private var types: [DependencyTypeKey: Any.Type] = [:]
    private var factories: [DependencyFactoryKey: (DependencyContainer) -> Any] = [:]
    private let serialQueue = DispatchQueue(label: "com.mindbodyonline.Relay.DynamicDependencyIndex")

    public init() {}

    /// Retrieves a registered type
    ///
    /// - Parameter typeKey: The type identifier
    /// - Returns: The registered type
    /// - Throws: A `DynamicDependencyIndexError` if index not found
    public func lookup(type typeKey: DependencyTypeKey) throws -> Any.Type {
        return try serialQueue.sync {
            guard let type = types[typeKey] else {
                throw DynamicDependencyIndexError.typeNotFound(identifier: typeKey.tag)
            }
            return type
        }
    }

    /// Retrieves a registered factory
    /// - Warning: If the index does not exist, then this function will crash
    ///
    /// - Parameter factoryKey: The factory identifier
    /// - Returns: The registered factory
    public func lookup(factory factoryKey: DependencyFactoryKey) throws -> (DependencyContainer) -> Any {
        return try serialQueue.sync {
            guard let factory = factories[factoryKey] else {
                throw DynamicDependencyIndexError.factoryNotFound(identifier: factoryKey.tag)
            }
            return factory
        }
    }

    /// Updates the dynamic dependency index with the provided dependency factory index
    /// - Parameter indexable: Provides a dependency factory index
    public func add(_ indexable: DependencyFactoryIndexable) {
        serialQueue.sync {
            let index = indexable.index
            index.forEach {
                factories[$0.key] = $0.value
            }
        }
    }

    /// Updates the dynamic dependency index with the provided dependency type index
    /// - Parameter indexable: Provides a dependency type index
    public func add(_ indexable: DependencyTypeIndexable) {
        serialQueue.sync {
            let index = indexable.index
            index.forEach {
                types[$0.key] = $0.value
            }
        }
    }

}

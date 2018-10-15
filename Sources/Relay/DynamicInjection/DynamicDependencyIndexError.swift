//
//  DynamicDependencyIndexError.swift
//  Relay
//
//  Created by John Hammerlund on 10/12/18.
//

import Foundation

public enum DynamicDependencyIndexError: LocalizedError {
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

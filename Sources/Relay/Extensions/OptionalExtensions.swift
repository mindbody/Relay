//
//  OptionalExtensions.swift
//  Relay
//
//  Created by John Hammerlund on 1/14/19.
//

import Foundation

/// Allows for compile-time type-erasure on `Optional`, useful for type-checking
protocol OptionalType {

    /// The wrapped type (erased)
    static var wrapped: Any.Type { get }

}

extension Optional: OptionalType {

    static var wrapped: Any.Type {
        return Wrapped.self
    }

}

extension OptionalType {

    /// The underlying type, which may be nested in multiple Optionals
    static var underlyingType: Any.Type {
        if let wrapped = wrapped as? OptionalType.Type {
            return wrapped.underlyingType
        }
        return wrapped
    }

}

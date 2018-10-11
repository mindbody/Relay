//
//  DependencyDefinition.swift
//  Relay
//
//  Created by John Hammerlund on 9/17/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// Describes an injectable dependency
public struct DependencyDefinition {

    /// The abstract type identifier
    public let typeIdentifier: DependencyTypeKey
    /// The concrete factory identifier
    public let factoryIdentifier: DependencyFactoryKey

    /// Creates a new DependencyDefinition
    ///
    /// - Parameters:
    ///   - typeIdentifier: The abstract type identifier
    ///   - factoryIdentifier: The concrete factory identifier
    public init(typeIdentifier: DependencyTypeKey, factoryIdentifier: DependencyFactoryKey) {
        self.typeIdentifier = typeIdentifier
        self.factoryIdentifier = factoryIdentifier
    }

}

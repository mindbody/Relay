//
//  DependencyMetaContainer.swift
//  Relay
//
//  Created by John Hammerlund on 9/17/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// Describes a DependencyContainer and all of its registered dependencies
public final class DependencyMetaContainer {

    /// The scope of injection
    public let scope: DependencyContainerScope
    /// A list of injectable dependencies
    public let definitions: [DependencyDefinition]

    /// Creates a new DependencyMetaContainer
    ///
    /// - Parameters:
    ///   - scope: The scope of injection
    ///   - definitions: A list of injectable dependencies
    public init(scope: DependencyContainerScope, definitions: [DependencyDefinition]) {
        self.scope = scope
        self.definitions = definitions
    }

}

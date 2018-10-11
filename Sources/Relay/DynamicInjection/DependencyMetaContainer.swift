//
//  DependencyMetaContainer.swift
//  Relay
//
//  Created by John Hammerlund on 9/17/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// Describes a DependencyContainer and all of its registered dependencies
final class DependencyMetaContainer {

    /// The scope of injection
    let scope: DependencyContainerScope
    /// A list of injectable dependencies
    let definitions: [DependencyDefinition]

    /// Creates a new DependencyMetaContainer
    ///
    /// - Parameters:
    ///   - scope: The scope of injection
    ///   - definitions: A list of injectable dependencies
    init(scope: DependencyContainerScope, definitions: [DependencyDefinition]) {
        self.scope = scope
        self.definitions = definitions
    }

}

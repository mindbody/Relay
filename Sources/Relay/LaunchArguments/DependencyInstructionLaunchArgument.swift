//
//  DependencyInstructionLaunchArgument.swift
//  Relay
//
//  Created by John Hammerlund on 9/20/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// A launch argument that instructs an application to inject a dependency, formatted as
/// `type=<type>,factory=<factory>,scope=<scope>`
public struct DependencyInstructionLaunchArgument: LaunchArgument {

    /// The abstract type identifier
    public let type: DependencyTypeKey
    /// The concrete factory identifier
    public let factory: DependencyFactoryKey
    /// The dependency scope, or "global" if set to nil
    public let scope: DependencyContainerScope?
    public let flag = "-d"
    public var value: String? {
        let argument = "type=\(type.tag),factory=\(factory.tag)"
        if let scope = scope {
            return "\(argument),scope=\(scope.value)"
        }
        return argument
    }

    /// Creates a new DependencyInstructionLaunchArgument
    ///
    /// - Parameters:
    ///   - type: The abstract type identifier
    ///   - factory: The concrete factory identifier
    ///   - scope: The dependency scope, or "global" if set to nil
    public init(type: DependencyTypeKey, factory: DependencyFactoryKey, scope: DependencyContainerScope? = nil) {
        self.type = type
        self.factory = factory
        self.scope = scope
    }

}

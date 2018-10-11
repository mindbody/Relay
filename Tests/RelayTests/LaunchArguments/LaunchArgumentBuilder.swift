//
//  LaunchArgumentBuilder.swift
//  Relay
//
//  Created by John Hammerlund on 9/20/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// Builds a list of command line arguments
public struct LaunchArgumentBuilder {

    private var arguments: [LaunchArgument]

    /// Creates a new LaunchArgumentBuilder
    ///
    /// - Parameter arguments: A list of launch arguments
    public init(arguments: [LaunchArgument]) {
        self.arguments = arguments
    }

    /// Adds a launch argument
    ///
    /// - Parameter argument: The launch argument to add
    public mutating func add(argument: LaunchArgument) {
        self.arguments.append(argument)
    }

    /// Adds a collection of launch argument
    ///
    /// - Parameter argument: The launch arguments to add
    public mutating func add(arguments: [LaunchArgument]) {
        self.arguments.append(contentsOf: arguments)
    }

    /// Builds a list of command line arguments
    ///
    /// - Returns: A list of command line arguments
    public func build() -> [String] {
        return arguments.flatMap { argument -> [String] in
            if let value = argument.value {
                return [argument.flag, value]
            }
            return [argument.flag]
        }
    }

}

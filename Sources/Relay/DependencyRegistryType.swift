//
//  DependencyRegistryType.swift
//  Relay
//
//  Created by John Hammerlund on 9/17/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// Registers global and scoped dependencies to associated IoC containers
public protocol DependencyRegistryType {

    /// Registers dependencies to necessary IoC containers
    func registerDependencies() throws

}

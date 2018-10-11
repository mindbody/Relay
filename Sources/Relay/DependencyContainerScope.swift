//
//  DependencyContainerScope.swift
//  Relay
//
//  Created by John Hammerlund on 9/17/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// A dependency component scope for injection
struct DependencyContainerScope: Hashable {

    let value: String

    init(_ value: String) {
        self.value = value
    }

}

extension DependencyContainerScope {

    static let global = DependencyContainerScope("global")

    /// Add additional component scopes here

}

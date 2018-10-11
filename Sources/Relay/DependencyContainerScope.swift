//
//  DependencyContainerScope.swift
//  Relay
//
//  Created by John Hammerlund on 9/17/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// A dependency component scope for injection
public struct DependencyContainerScope: Hashable {

    public let value: String

    public init(_ value: String) {
        self.value = value
    }

}

extension DependencyContainerScope {

    /// For application-wide injection
    public static let global = DependencyContainerScope("global")

}

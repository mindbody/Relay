//
//  DependencyFactoryKey.swift
//  Relay
//
//  Created by John Hammerlund on 9/17/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// Uniquely identifies a concrete factory for dependency injection
public struct DependencyFactoryKey: Hashable {

    public static func == (lhs: DependencyFactoryKey, rhs: DependencyFactoryKey) -> Bool {
        return lhs.tag == rhs.tag
    }

    public let tag: String
    public var hashValue: Int {
        return "\(tag)".hashValue
    }

    public init(_ tag: String) {
        self.tag = tag
    }

}

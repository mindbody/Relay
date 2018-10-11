//
//  DependencyTypeKey.swift
//  Relay
//
//  Created by John Hammerlund on 9/17/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// Uniquely identifies an abstract type for dependency injection
public struct DependencyTypeKey: Hashable {

    public static func == (lhs: DependencyTypeKey, rhs: DependencyTypeKey) -> Bool {
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

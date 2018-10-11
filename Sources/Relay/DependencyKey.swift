//
//  DependencyKey.swift
//  Relay
//
//  Created by John Hammerlund on 9/17/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// Uniquely identifies an injected dependency
public struct DependencyKey: Hashable {

    public static func == (lhs: DependencyKey, rhs: DependencyKey) -> Bool {
        return lhs.type == rhs.type
    }

    private let type: Any.Type
    public var hashValue: Int {
        return "\(type)".hashValue
    }

    public init(_ type: Any.Type) {
        self.type = type
    }

}

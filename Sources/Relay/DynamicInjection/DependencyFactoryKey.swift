//
//  DependencyFactoryKey.swift
//  Relay
//
//  Created by John Hammerlund on 9/17/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// Uniquely identifies a concrete factory for dependency injection
struct DependencyFactoryKey: Hashable {

    static func == (lhs: DependencyFactoryKey, rhs: DependencyFactoryKey) -> Bool {
        return lhs.tag == rhs.tag
    }

    let tag: String
    var hashValue: Int {
        return "\(tag)".hashValue
    }

    init(_ tag: String) {
        self.tag = tag
    }

}

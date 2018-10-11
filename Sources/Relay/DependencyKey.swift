//
//  DependencyKey.swift
//  Relay
//
//  Created by John Hammerlund on 9/17/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// Uniquely identifies an injected dependency
struct DependencyKey: Hashable {

    static func == (lhs: DependencyKey, rhs: DependencyKey) -> Bool {
        return lhs.type == rhs.type
    }

    private let type: Any.Type
    var hashValue: Int {
        return "\(type)".hashValue
    }

    init(_ type: Any.Type) {
        self.type = type
    }

}

//
//  LifecycleTypeExtensions.swift
//  Relay
//
//  Created by John Hammerlund on 10/19/18.
//

import Foundation

extension LifecycleType {

    private static let transientIdentifier = "transient"
    private static let singletonIdentifier = "singleton"

    init?(identifier: String) {
        switch identifier {
        case LifecycleType.transientIdentifier:
            self = .transient
        case LifecycleType.singletonIdentifier:
            self = .singleton
        default:
            return nil
        }
    }

    var identifier: String {
        switch self {
        case .transient:
            return LifecycleType.transientIdentifier
        case .singleton:
            return LifecycleType.singletonIdentifier
        }
    }

}

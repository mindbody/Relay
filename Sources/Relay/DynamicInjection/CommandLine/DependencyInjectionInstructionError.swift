//
//  DependencyInjectionInstructionError.swift
//  Relay
//
//  Created by John Hammerlund on 10/5/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

enum DependencyInjectionInstructionError: LocalizedError {

    case malformattedDependencyParameter(String)
    case unrecognizedParameter(String)
    case missingType
    case missingFactory
    case missingDependencyIdentifier

    var errorDescription: String? {
        switch self {
        case let .malformattedDependencyParameter(parameter):
            return "Malformatted custom dependency parameter: \"\(parameter)\""
        case let .unrecognizedParameter(parameter):
            return "Unrecognized custom dependency parameter: \"\(parameter)\""
        case .missingType:
            return "Abstract dependency type identifier is required"
        case .missingFactory:
            return "Concrete dependency factory identifier is required"
        case .missingDependencyIdentifier:
            return "Custom dependency identifier not specified"
        }
    }

    var recoverySuggestion: String? {
        return "Dependency injection instructions should be formatted properly: 'type=<type>,factory=<factory>,scope=<scope>'"
    }

}

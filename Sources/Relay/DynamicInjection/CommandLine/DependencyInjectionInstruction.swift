//
//  DependencyInjectionInstruction.swift
//  Relay
//
//  Created by John Hammerlund on 9/18/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// An instruction to inject a dependency for a given type within a component scope
struct DependencyInjectionInstruction {

    /// The abstract type identifier
    let typeIdentifier: String
    /// The concrete factory identifier
    let factoryIdentifier: String
    /// The component scope (defaults to "global")
    let scope: String
    /// The lifecycle type (defaults to "singleton")
    let lifecycle: String

    init(typeIdentifier: String, factoryIdentifier: String, scope: String = "global", lifecycle: String = LifecycleType.singleton.identifier) {
        self.typeIdentifier = typeIdentifier
        self.factoryIdentifier = factoryIdentifier
        self.scope = scope
        self.lifecycle = lifecycle
    }

}

extension DependencyInjectionInstruction {

    /// Creates a new DependencyInjectionInstruction from command line input
    ///
    /// - Parameter commandLineIdentifier: The command line input, formatted as `type=<type>,factory=<factory>,scope=<scope>,lifecycle=<lifecycle>`
    init(commandLineIdentifier: String) throws {
        let parameters = commandLineIdentifier.components(separatedBy: ",")

        var typeTag: String?
        var factoryTag: String?
        var scope: String?
        var lifecycle = LifecycleType.singleton.identifier

        for parameter in parameters {
            let keyValuePair = parameter.components(separatedBy: "=")
            if keyValuePair.count != 2 {
                throw DependencyInjectionInstructionError.malformattedDependencyParameter(parameter)
            }
            let key = keyValuePair[0].trimmingCharacters(in: .whitespaces)
            let value = keyValuePair[1].trimmingCharacters(in: .whitespaces)
            guard key.isEmpty == false, value.isEmpty == false else {
                throw DependencyInjectionInstructionError.malformattedDependencyParameter(parameter)
            }

            switch key {
            case "type":
                typeTag = value
            case "factory":
                factoryTag = value
            case "scope":
                scope = value
            case "lifecycle":
                lifecycle = value.lowercased()
            default:
                throw DependencyInjectionInstructionError.unrecognizedParameter(parameter)
            }
        }

        let lifecycleIdentifiers = LifecycleType.allCases.map { $0.identifier }
        guard lifecycleIdentifiers.contains(lifecycle) else {
            throw DependencyInjectionInstructionError.malformattedDependencyParameter("lifecycle")
        }

        guard let type = typeTag else {
            throw DependencyInjectionInstructionError.missingType
        }
        guard let factory = factoryTag else {
            throw DependencyInjectionInstructionError.missingFactory
        }

        if let scope = scope {
            self.init(typeIdentifier: type, factoryIdentifier: factory, scope: scope, lifecycle: lifecycle)
        }
        else {
            self.init(typeIdentifier: type, factoryIdentifier: factory, lifecycle: lifecycle)
        }
    }

}

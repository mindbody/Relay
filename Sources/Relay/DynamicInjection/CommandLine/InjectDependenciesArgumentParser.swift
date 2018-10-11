//
//  DependencyArgumentParser.swift
//  Relay
//
//  Created by John Hammerlund on 9/18/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

/// Parses custom dependency launch arguments, specified by "-d" or "--dependency" (can add as many as needed).
/// Each resolved type and factory will be registered to the IoC container with associated scope (default "global").
/// Type mismatches or unrecognized types/factories will cause a crash.
///
/// **Example format**: `<run> -d type=AbstractType,factory=ConcreteType,scope=SampleViewController`
final class InjectDependenciesArgumentParser: ArgumentParser {

    private let index: DynamicDependencyIndex

    init(index: DynamicDependencyIndex = .shared) {
        self.index = index
    }

    func canParse(arguments: [String]) -> Bool {
        return arguments.contains("-d") || arguments.contains("--dependency")
    }

    func parse(arguments: [String]) throws {
        var dependencyIdentifiers: [String] = []

        for index in 0..<arguments.count {
            let argument = arguments[index]
            if ["-d", "--dependency"].contains(argument) {
                let inputIndex = index + 1
                if inputIndex >= arguments.count {
                    throw DependencyInjectionInstructionError.missingDependencyIdentifier
                }
                dependencyIdentifiers.append(arguments[inputIndex])
            }
        }

        let injectionInstructions = try dependencyIdentifiers.map { try DependencyInjectionInstruction(commandLineIdentifier: $0) }
        let dependencyDictionary = Dictionary(grouping: injectionInstructions) { $0.scope }

        var metaContainers: [DependencyMetaContainer] = []

        for (key, instructions) in dependencyDictionary {
            let scope = DependencyContainerScope(key)
            var definitions: [DependencyDefinition] = []

            for instruction in instructions {
                let definition = DependencyDefinition(typeIdentifier: DependencyTypeKey(instruction.typeIdentifier),
                                                      factoryIdentifier: DependencyFactoryKey(instruction.factoryIdentifier))
                definitions.append(definition)
            }

            let metaContainer = DependencyMetaContainer(scope: scope, definitions: definitions)
            metaContainers.append(metaContainer)
        }

        let dependencyRegistry = DynamicDependencyRegistry(index: index, metaContainers: metaContainers)
        try dependencyRegistry.registerDependencies()
    }

}

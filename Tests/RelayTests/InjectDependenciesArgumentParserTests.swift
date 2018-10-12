//
//  InjectDependenciesArgumentParserTests.swift
//  RelayTests
//
//  Created by John Hammerlund on 10/5/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import XCTest
import Relay

// swiftlint:disable nesting

final class InjectDependenciesArgumentParserTests: XCTestCase {

    func testBridgesDependencyInstructionsToDynamicRegistry() throws {
        class ImplementsA: DynamicTypeA { }
        class ImplementsB: DynamicTypeB { }
        let factoryA: (DependencyContainer) -> Any = { _ in ImplementsA() }
        let factoryB: (DependencyContainer) -> Any = { _ in ImplementsB() }

        let typeIndex = TestDynamicTypeIndex(index: [
            .dynamicTypeA: DynamicTypeA.self,
            .dynamicTypeB: DynamicTypeB.self
            ])
        let factoryIndex = TestDynamicFactoryIndex(index: [
            .dynamicFactoryA: factoryA,
            .dynamicFactoryB: factoryB
            ])

        let index = DynamicDependencyIndex()
        index.add(typeIndex)
        index.add(factoryIndex)

        let scopeIdentifier = "DynamicDependencyInjectionTests.customScope"
        let customScope = DependencyContainerScope(scopeIdentifier)

        let commandLineArguments: [String] = [
            "--dependency", "type=DynamicDependencyInjectionTests.dynamicTypeA,factory=DynamicDependencyInjectionTests.dynamicFactoryA",
            "-d", "type=DynamicDependencyInjectionTests.dynamicTypeB,factory=DynamicDependencyInjectionTests.dynamicFactoryB,scope=\(scopeIdentifier)"
        ]

        let sut = InjectDependenciesArgumentParser(index: index)
        XCTAssert(sut.canParse(arguments: commandLineArguments))

        try sut.parse(arguments: commandLineArguments)

        let globalContainer = DependencyContainer.global
        let customContainer = DependencyContainer.container(for: customScope)

        XCTAssert(globalContainer.resolve(DynamicTypeA.self) is ImplementsA)
        XCTAssert(customContainer.resolve(DynamicTypeB.self) is ImplementsB)
    }

    func testThrowsForMissingDependencyInstructions() throws {
        let commandLineArguments: [String] = ["-d"]

        let sut = InjectDependenciesArgumentParser()
        XCTAssertThrowsError(try sut.parse(arguments: commandLineArguments))
    }

    func testCanOnlyParseDependencyFlags() throws {
        let sut = InjectDependenciesArgumentParser()

        XCTAssert(sut.canParse(arguments: ["-d"]))
        XCTAssert(sut.canParse(arguments: ["--dependency"]))
        XCTAssertFalse(sut.canParse(arguments: ["type=typeA,factory=factoryA"]))
    }

}
// swiftlint:enable nesting

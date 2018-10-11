//
//  DynamicDependencyRegistryTests.swift
//  RelayTests
//
//  Created by John Hammerlund on 10/5/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import XCTest
@testable import Relay

final class DynamicDependencyRegistryTests: XCTestCase {

    func testRegistersDynamicDependencies() throws {
        let factoryA: (DependencyContainer) -> Any = { _ in ImplementsDynamicTypeA() }
        let factoryB: (DependencyContainer) -> Any = { _ in ImplementsDynamicTypeB() }
        let factoryC: (DependencyContainer) -> Any = { _ in ImplementsDynamicTypeC() }

        let typeIndex = TestDynamicTypeIndex(index: [
            .dynamicTypeA: DynamicTypeA.self,
            .dynamicTypeB: DynamicTypeB.self,
            .dynamicTypeC: DynamicTypeC.self
            ])
        let factoryIndex = TestDynamicFactoryIndex(index: [
            .dynamicFactoryA: factoryA,
            .dynamicFactoryB: factoryB,
            .dynamicFactoryC: factoryC
            ])

        let index = DynamicDependencyIndex()
        index.add(typeIndex)
        index.add(factoryIndex)

        let customScope = DependencyContainerScope(#function)
        let metaContainers = [
            DependencyMetaContainer(scope: .global, definitions: [
                DependencyDefinition(typeIdentifier: .dynamicTypeA, factoryIdentifier: .dynamicFactoryA),
                DependencyDefinition(typeIdentifier: .dynamicTypeB, factoryIdentifier: .dynamicFactoryB)
                ]),
            DependencyMetaContainer(scope: customScope, definitions: [
                DependencyDefinition(typeIdentifier: .dynamicTypeC, factoryIdentifier: .dynamicFactoryC)
                ])
        ]

        let sut = DynamicDependencyRegistry(index: index, metaContainers: metaContainers)
        try sut.registerDependencies()

        let globalContainer = DependencyContainer.global
        let customContainer = DependencyContainer.container(for: customScope)

        XCTAssert(globalContainer.resolve(DynamicTypeA.self) is ImplementsDynamicTypeA)
        XCTAssert(globalContainer.resolve(DynamicTypeB.self) is ImplementsDynamicTypeB)
        XCTAssert(customContainer.resolve(DynamicTypeC.self) is ImplementsDynamicTypeC)
    }

    func testThrowsForUnknownTypes() throws {
        let factoryA: (DependencyContainer) -> Any = { _ in ImplementsDynamicTypeA() }

        let metaContainer = DependencyMetaContainer(scope: .global, definitions: [
            DependencyDefinition(typeIdentifier: .dynamicTypeA, factoryIdentifier: .dynamicFactoryA)
            ])

        let factoryIndex = TestDynamicFactoryIndex(index: [.dynamicFactoryA: factoryA])
        let index = DynamicDependencyIndex()
        index.add(factoryIndex)

        let sut = DynamicDependencyRegistry(index: index, metaContainers: [metaContainer])
        XCTAssertThrowsError(try sut.registerDependencies())
    }

    func testThrowsForUnknownFactories() throws {
        let metaContainer = DependencyMetaContainer(scope: .global, definitions: [
            DependencyDefinition(typeIdentifier: .dynamicTypeA, factoryIdentifier: .dynamicFactoryA)
            ])

        let typeIndex = TestDynamicTypeIndex(index: [.dynamicTypeA: DynamicTypeA.self])
        let index = DynamicDependencyIndex()
        index.add(typeIndex)

        let sut = DynamicDependencyRegistry(index: index, metaContainers: [metaContainer])
        XCTAssertThrowsError(try sut.registerDependencies())
    }

}

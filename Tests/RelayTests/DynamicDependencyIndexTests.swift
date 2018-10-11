//
//  DynamicDependencyIndexTests.swift
//  RelayTests
//
//  Created by John Hammerlund on 10/5/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import XCTest
import Relay

final class DynamicDependencyIndexTests: XCTestCase {

    func testIndexesTypes() throws {
        let sut = DynamicDependencyIndex()

        let typeIndex = TestDynamicTypeIndex(index: [.dynamicTypeA: DynamicTypeA.self])
        sut.add(typeIndex)

        let indexedType = try sut.lookup(type: .dynamicTypeA)
        XCTAssert(indexedType == DynamicTypeA.self)
    }

    func testIndexesFactories() throws {
        let sut = DynamicDependencyIndex()
        let factory: (DependencyContainer) -> Any = { _ in ImplementsDynamicTypeA() }
        let factoryIndex = TestDynamicFactoryIndex(index: [.dynamicFactoryA: factory])
        sut.add(factoryIndex)

        let indexedFactory = try sut.lookup(factory: .dynamicFactoryA)
        XCTAssert(indexedFactory(DependencyContainer.global) is ImplementsDynamicTypeA)
    }

    func testThrowsOnLookupsWhenTypeIndexDoesNotExist() throws {
        let sut = DynamicDependencyIndex()

        let unknownKey = DependencyTypeKey("DynamicDependencyIndexTests.unknownKey")
        XCTAssertThrowsError(try sut.lookup(type: unknownKey), "Type lookup throws error") { error in
            switch error {
            case let DynamicDependencyIndexError.typeNotFound(identifier: identifier):
                XCTAssertEqual(identifier, unknownKey.tag)
            default:
                XCTFail("Incorrect error thrown")
            }
        }
    }

    func testThrowsOnLookupsWhenFactoryIndexDoesNotExist() throws {
        let sut = DynamicDependencyIndex()

        let unknownKey = DependencyFactoryKey("DynamicDependencyIndexTests.unknownKey")
        XCTAssertThrowsError(try sut.lookup(factory: unknownKey), "Factory lookup throws error") { error in
            switch error {
            case let DynamicDependencyIndexError.factoryNotFound(identifier: identifier):
                XCTAssertEqual(identifier, unknownKey.tag)
            default:
                XCTFail("Incorrect error thrown")
            }
        }
    }

}

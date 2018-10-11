//
//  DependencyContainerTests.swift
//  RelayTests
//
//  Created by John Hammerlund on 9/12/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import XCTest
@testable import Relay

private protocol TypeA { }
private protocol TypeB { }
private protocol TypeC { }
private protocol TypeD: class { }
private protocol TypeE: class { }
private protocol TypeF: class { }

// swiftlint:disable nesting
final class DependencyContainerTests: XCTestCase {

    func testRegistersTypes() throws {
        class ImplementsA: TypeA { }

        DependencyContainer.global.register(TypeA.self) { _ in ImplementsA() }

        XCTAssert(DependencyContainer.global.resolve(TypeA.self) is ImplementsA)
    }

    func testRegistersTypesAtComponentScope() throws {
        class ImplementsB: TypeB { }
        class AlsoImplementsB: TypeB { }

        DependencyContainer.global.register(TypeB.self) { _ in ImplementsB() }

        let scope = DependencyContainerScope(#function)
        let sut = DependencyContainer.container(for: scope)

        sut.register(TypeB.self) { _ in AlsoImplementsB() }

        XCTAssert(sut.resolve(TypeB.self) is AlsoImplementsB)
    }

    func testComponentContainersFallBackToGlobalScope() throws {
        class ImplementsC: TypeC { }

        DependencyContainer.global.register(TypeC.self) { _ in ImplementsC() }

        let scope = DependencyContainerScope(#function)
        let sut = DependencyContainer.container(for: scope)

        XCTAssert(sut.resolve(TypeC.self) is ImplementsC)
    }

    func testLazyLoadsDependencies() throws {
        class ImplementsD: TypeD { }

        DependencyContainer.global.register(TypeD.self) { _ in ImplementsD() }
        let dependency = DependencyContainer.global.resolve(TypeD.self)
        XCTAssert(dependency === DependencyContainer.global.resolve(TypeD.self))
    }

    func testResolvesLazyCircularDependencies() throws {
        class ImplementsE: TypeE {
            lazy var nested: TypeF = {
                let scope = DependencyContainerScope(#function)
                return DependencyContainer.container(for: scope).resolve()
            }()
        }
        class ImplementsF: TypeF {
            let nested: TypeE

            init(nested: TypeE) {
                self.nested = nested
            }
        }

        let scope = DependencyContainerScope(#function)
        let sut = DependencyContainer.container(for: scope)

        sut.register(TypeE.self) { _ in ImplementsE() }
        sut.register(TypeF.self) { container in
            ImplementsF(nested: container.resolve(TypeE.self))
        }

        guard let implementsF = sut.resolve(TypeF.self) as? ImplementsF else {
            XCTFail("Failed to resolve type")
            return
        }

        XCTAssert(implementsF.nested === sut.resolve(TypeE.self))
    }

}
// swiftlint:enable nesting
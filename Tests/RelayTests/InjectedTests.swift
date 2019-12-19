//
//  InjectedTests.swift
//  Relay
//
//  Created by John Hammerlund on 12/17/19.
//

#if swift(>=5.1)

import XCTest
import Relay

private protocol TypeA: class { }
private protocol TypeB: class { }
private protocol TypeC: class { }
private protocol TypeD: class { }
private class ImplementsA: TypeA { }
private class ImplementsB: TypeB { }
private class ImplementsC: TypeC { }
private class ImplementsD: TypeD { }

extension DependencyContainerScope {
    static let propertyWrapper = DependencyContainerScope("injected-tests")
}

// swiftlint:disable nesting

final class InjectedTests: XCTestCase {

    func testResolvesDependenciesFromGlobalContainer() throws {
        let expectedDependency = ImplementsA()

        DependencyContainer.global.register(TypeA.self) { _ in expectedDependency }

        class SampleClass {
            @Injected var implementsA: TypeA
        }

        let instance = SampleClass()

        XCTAssert(instance.implementsA === expectedDependency)
    }

    func testResolvesDependenciesFromContextualContainer() throws {
        let scope = DependencyContainerScope.propertyWrapper
        let container = DependencyContainer.container(for: scope)

        let expectedDependency = ImplementsB()

        DependencyContainer.global.register(TypeB.self) { _ in
            XCTFail("Factory should not be called")
            return ImplementsB()
        }
        container.register(TypeB.self) { _ in expectedDependency }

        class SampleClass {
            @Injected(scope: .propertyWrapper) var implementsB: TypeB
        }

        let instance = SampleClass()

        XCTAssert(instance.implementsB === expectedDependency)
    }

    func testLazilyInjectsPropertyValue() throws {
        DependencyContainer.global.register(TypeC.self) { _ in
            XCTFail("Factory should not be called")
            return ImplementsC()
        }

        class SampleClass {
            @Injected var implementsC: TypeC
        }

        _ = SampleClass()
    }

    func testAllowsValueReplacement() throws {
        let injectedDependency = ImplementsD()
        DependencyContainer.global.register(TypeD.self) { _ in
            XCTFail("Factory should not be called")
            return ImplementsD()
        }

        class SampleClass {
            @Injected var implementsD: TypeD
        }

        let instance = SampleClass()
        instance.implementsD = ImplementsD()

        XCTAssert(instance.implementsD !== injectedDependency)
    }

}

#endif

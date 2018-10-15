//
//  DependencyInstructionLaunchArgumentTests.swift
//  Relay
//
//  Created by John Hammerlund on 10/12/18.
//

import XCTest
import Relay

final class DependencyInstructionLaunchArgumentTests: XCTestCase {

    func testFormatsInjectionInstructions() throws {
        let testTypeA = DependencyTypeKey("typeA")
        let testFactoryA = DependencyFactoryKey("factoryA")
        let testTypeB = DependencyTypeKey("typeB")
        let testFactoryB = DependencyFactoryKey("factoryB")
        let scopeB = DependencyContainerScope("scopeB")

        let instructionA = DependencyInstructionLaunchArgument(type: testTypeA, factory: testFactoryA)
        let instructionB = DependencyInstructionLaunchArgument(type: testTypeB, factory: testFactoryB, scope: scopeB)

        XCTAssertEqual(instructionA.flag, "-d")
        XCTAssertEqual(instructionA.value, "type=\(testTypeA.tag),factory=\(testFactoryA.tag)")
        XCTAssertEqual(instructionB.flag, "-d")
        XCTAssertEqual(instructionB.value, "type=\(testTypeB.tag),factory=\(testFactoryB.tag),scope=\(scopeB.value)")
    }

}

//
//  DependencyInjectionInstructionTests.swift
//  RelayTests
//
//  Created by John Hammerlund on 10/5/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import XCTest
@testable import Relay

final class DependencyInjectionInstructionTests: XCTestCase {

    func testParsesCommandLineIdentifiers() throws {
        let validIdentifier = "type=sampleType,factory=sampleFactory,scope=👌🏻"
        let validIdentiferWithoutScope = "type  =  sampleType2,     factory  =  sampleFactory2"

        var sut = try DependencyInjectionInstruction(commandLineIdentifier: validIdentifier)
        XCTAssertEqual(sut.typeIdentifier, "sampleType")
        XCTAssertEqual(sut.factoryIdentifier, "sampleFactory")
        XCTAssertEqual(sut.scope, "👌🏻")

        sut = try DependencyInjectionInstruction(commandLineIdentifier: validIdentiferWithoutScope)
        XCTAssertEqual(sut.typeIdentifier, "sampleType2")
        XCTAssertEqual(sut.factoryIdentifier, "sampleFactory2")
        XCTAssertEqual(sut.scope, "global")
    }

    func testThrowsOnMalformattedParameters() throws {
        let malformattedIdentifiers = [
            "type=sampleType=,factory=sampleFactory",
            "type=,factory=sampleFactory",
            "="
        ]

        for identifier in malformattedIdentifiers {
            XCTAssertThrowsError(try DependencyInjectionInstruction(commandLineIdentifier: identifier), "Throws malformatted error") { error in
                switch error {
                case DependencyInjectionInstructionError.malformattedDependencyParameter:
                    return
                default:
                    XCTFail("Incorrect error thrown")
                }
            }
        }
    }

    func testThrowsOnUnrecognizedParameters() throws {
        let identifiersWithUnrecognizedParameters = [
            "type=sampleType,factory=sampleFactory,scopee=global",
            "type=sampleType,factory=sampleFactory,scope=global,customKey=customValue"
        ]

        for identifier in identifiersWithUnrecognizedParameters {
            XCTAssertThrowsError(try DependencyInjectionInstruction(commandLineIdentifier: identifier), "Throws unrecognized error") { error in
                switch error {
                case DependencyInjectionInstructionError.unrecognizedParameter:
                    return
                default:
                    XCTFail("Incorrect error thrown")
                }
            }
        }
    }

    func testThrowsForMissingType() throws {
        let identifiersWithMissingTypes = [
            "factory=sampleFactory",
            "factory=sampleFactory,scope=global"
        ]

        for identifier in identifiersWithMissingTypes {
            XCTAssertThrowsError(try DependencyInjectionInstruction(commandLineIdentifier: identifier), "Throws missing type error") { error in
                switch error {
                case DependencyInjectionInstructionError.missingType:
                    return
                default:
                    XCTFail("Incorrect error thrown")
                }
            }
        }
    }

    func testThrowsForMissingFactory() throws {
        let identifiersWithMissingFactories = [
            "type=sampleType",
            "type=sampleType,scope=global"
        ]

        for identifier in identifiersWithMissingFactories {
            XCTAssertThrowsError(try DependencyInjectionInstruction(commandLineIdentifier: identifier), "Throws missing type error") { error in
                switch error {
                case DependencyInjectionInstructionError.missingFactory:
                    return
                default:
                    XCTFail("Incorrect error thrown")
                }
            }
        }
    }

}

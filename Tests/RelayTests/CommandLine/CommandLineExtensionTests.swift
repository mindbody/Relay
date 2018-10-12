//
//  CommandLineExtensionTests.swift
//  Relay
//
//  Created by John Hammerlund on 10/12/18.
//

import XCTest
import Relay

private enum TestLaunchArgumentParseError: Error {
    case failed
}

private class TestLaunchArgumentParser: ArgumentParser {
    let canParse: Bool
    var shouldThrow = false
    private(set) var parsedArguments: [String] = []

    init(canParse: Bool) {
        self.canParse = canParse
    }

    func canParse(arguments: [String]) -> Bool {
        return canParse
    }

    func parse(arguments: [String]) throws {
        if canParse == false || shouldThrow {
            throw TestLaunchArgumentParseError.failed
        }
        parsedArguments = arguments
    }
}

class CommandLineExtensionTests: XCTestCase {

    var commandLineArguments: [String]!

    override func setUp() {
        super.setUp()
        commandLineArguments = CommandLine.arguments
    }

    override func tearDown() {
        super.tearDown()
        CommandLine.arguments = commandLineArguments
    }

    func testParsesLaunchArguments() throws {
        let arguments = [
            "-d",
            "type=typeA,factory=factoryA",
            "--dependency",
            "type=typeB,factory=factoryB,scope=sampleScope"
        ]
        CommandLine.arguments = arguments
        let parsers = [
            TestLaunchArgumentParser(canParse: true),
            TestLaunchArgumentParser(canParse: true),
            TestLaunchArgumentParser(canParse: true)
        ]
        try CommandLine.parse(with: parsers)
        for parser in parsers {
            XCTAssertEqual(arguments, parser.parsedArguments)
        }
    }

    func testOnlyParsesWithEligibleArgumentParsers() throws {
        let parserA = TestLaunchArgumentParser(canParse: true)
        let parserB = TestLaunchArgumentParser(canParse: false)

        let arguments = [#function]
        CommandLine.arguments = arguments

        try CommandLine.parse(with: [parserA, parserB])

        XCTAssertEqual(parserA.parsedArguments, arguments)
        XCTAssert(parserB.parsedArguments.isEmpty)
    }

    func testThrowsParseErrors() throws {
        let parser = TestLaunchArgumentParser(canParse: true)
        parser.shouldThrow = true

        XCTAssertThrowsError(try CommandLine.parse(with: [parser]))
    }

}

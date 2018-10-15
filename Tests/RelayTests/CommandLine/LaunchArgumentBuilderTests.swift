//
//  LaunchArgumentBuilderTests.swift
//  Relay
//
//  Created by John Hammerlund on 10/12/18.
//

import XCTest
import Relay

private struct TestLaunchArgument: LaunchArgument {
    let flag: String
    let value: String?
}

final class LaunchArgumentBuilderTests: XCTestCase {

    func testBuildsCommandLineArguments() throws {
        let argumentA = TestLaunchArgument(flag: "-f", value: "   sample\ntext  ")
        let argumentB = TestLaunchArgument(flag: "-v", value: nil)
        let argumentC = TestLaunchArgument(flag: "--dependency", value: "type=typeA,factory=factoryA")

        var sut = LaunchArgumentBuilder(arguments: [argumentA])
        sut.add(argument: argumentB)
        sut.add(arguments: [argumentC])

        let arguments = sut.build()

        let expected = [
            "-f", "   sample\ntext  ",
            "-v",
            "--dependency", "type=typeA,factory=factoryA"
        ]
        XCTAssertEqual(arguments, expected)
    }

}

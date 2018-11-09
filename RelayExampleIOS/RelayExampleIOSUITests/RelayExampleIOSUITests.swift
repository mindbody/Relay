//
//  RelayExampleIOSUITests.swift
//  RelayExampleIOSUITests
//
//  Created by John Hammerlund on 10/31/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import XCTest
import Relay

final class RelayExampleIOSUITests: XCTestCase {

    func testDisplaysRecipe() {
        let app = XCUIApplication()

        let injectionLaunchArgument = DependencyInstructionLaunchArgument(type: .recipeService, factory: .testRecipeService)
        let builder = LaunchArgumentBuilder(arguments: [injectionLaunchArgument])
        app.launchArguments = builder.build()

        app.launch()

        let nameLabel = app.staticTexts["recipe-details.label.name"]
        let ingredientsLabel = app.staticTexts["recipe-details.label.ingredients-list"]
        let instructionsLabel = app.staticTexts["recipe-details.label.instructions-list"]

        XCTAssertEqual(nameLabel.label, "Dynamic Dependency Injection")
        XCTAssertEqual(ingredientsLabel.label, "- 2 injected dependencies\n")
        XCTAssertEqual(instructionsLabel.label, """
1. Index all dynamic dependencies at app launch.

2. Pass dependency injection instructions to command line. Serve hot.


"""
        )
    }

}

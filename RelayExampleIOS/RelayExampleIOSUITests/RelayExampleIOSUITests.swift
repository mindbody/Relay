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

    /// Sample Test Case
    ///
    func testDisplaysRecipe() {
        let app = XCUIApplication()

        /// A DependencyInstructionLaunchArgument pre-formats dynamic injection instructions.
        /// In this example, we're sending a command line argument to inject a specific `RecipeServiceStub`
        /// for the global `RecipeServiceType`. This allows us to make focused, consistent assertions on the UI.

        let injectionLaunchArgument = DependencyInstructionLaunchArgument(type: .recipeService, factory: .testRecipeService)
        let builder = LaunchArgumentBuilder(arguments: [injectionLaunchArgument])
        app.launchArguments = builder.build()

        /// GIVEN I launch the app

        app.launch()

        /// WHEN the recipe screen displays
        /// THEN I should see a list of itemized ingredients and instructions

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

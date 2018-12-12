//
//  RelayUITestFactoryIndex.swift
//  RelayExampleIOSUITests
//
//  Created by John Hammerlund on 11/2/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation
import Relay

final class RelayUITestFactoryIndex: DependencyFactoryIndexable {

    let index: [DependencyFactoryKey: (DependencyContainer) -> Any] = RelayUITestFactoryIndex.makeIndex()

    private static func makeIndex() -> [DependencyFactoryKey: (DependencyContainer) -> Any] {
        let mockIngredient = RecipeIngredient(quantity: "2", ingredient: "injected dependencies")
        let mockInstructions = [
            RecipeInstruction(instruction: "Index all dynamic dependencies at app launch."),
            RecipeInstruction(instruction: "Pass dependency injection instructions to command line. Serve hot.")
        ]
        let mockRecipe = Recipe(name: "Dynamic Dependency Injection", ingredients: [mockIngredient], instructions: mockInstructions)

        let recipeServiceFactory: (DependencyContainer) -> Any = { _ in
            RecipeServiceStub(recipe: mockRecipe)
        }

        let mockViewModel = RecipeViewModel(recipeName: "🍔", formattedIngredients: "🥩🍞🍅🥗", formattedInstructions: "🍳")

        let recipeDataStoreFactory: (DependencyContainer) -> Any = { _ in
            RecipeDataStoreStub(viewModel: mockViewModel)
        }

        return [
            .testRecipeService: recipeServiceFactory,
            .testRecipeDataStore: recipeDataStoreFactory
        ]
    }

}

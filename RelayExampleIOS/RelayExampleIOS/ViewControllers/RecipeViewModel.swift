//
//  RecipeViewModel.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 10/31/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

struct RecipeViewModel {

    let recipeName: String
    let formattedIngredients: String
    let formattedInstructions: String

    init(recipeName: String, formattedIngredients: String, formattedInstructions: String) {
        self.recipeName = recipeName
        self.formattedIngredients = formattedIngredients
        self.formattedInstructions = formattedInstructions
    }
}

extension RecipeViewModel {

    init(recipe: Recipe) {
        let ingredients = recipe.ingredients.reduce("") { result, recipeIngredient in
            let item: String
            if let quantity = recipeIngredient.quantity {
                item = "\(quantity) \(recipeIngredient.ingredient)"
            }
            else {
                item = recipeIngredient.ingredient
            }
            return "\(result)- \(item)\n"
        }
        let instructions = recipe.instructions.enumerated().reduce("") { result, enumeratedRecipe in
            let order = enumeratedRecipe.offset + 1
            let instruction = enumeratedRecipe.element.instruction
            return "\(result)\(order). \(instruction)\n\n"
        }
        self.init(recipeName: recipe.name, formattedIngredients: ingredients, formattedInstructions: instructions)
    }

}

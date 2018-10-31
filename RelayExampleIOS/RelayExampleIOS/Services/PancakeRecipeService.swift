//
//  PancakeRecipeService.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 10/31/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

final class PancakeRecipeService: RecipeServiceType {

    func fetchRecipe() -> Recipe {
        let ingredients = [
            RecipeIngredient(quantity: "1 1/4 cups", ingredient: "all purpose flour"),
            RecipeIngredient(quantity: "1/2 teaspoon", ingredient: "salt"),
            RecipeIngredient(quantity: "1 tablespoon", ingredient: "baking powder"),
            RecipeIngredient(quantity: "1/2 teaspoon", ingredient: "baking soda"),
            RecipeIngredient(quantity: "1 1/4 teaspoon", ingredient: "white sugar"),
            RecipeIngredient(quantity: "1", ingredient: "egg"),
            RecipeIngredient(quantity: "1 cup", ingredient: "milk"),
            RecipeIngredient(quantity: "1/2 tablespoon", ingredient: "butter, melted"),
            RecipeIngredient(quantity: "1/2 cup", ingredient: "fresh or frozen blueberries, thawed")
        ]

        let firstInstruction = RecipeInstruction(instruction: "In a large bowl, sift together flour, salt, baking powder and sugar. In a small bowl, beat together egg and milk. Stir milk and egg into flour mixture. Mix in the butter and fold in the blueberries. Set aside for 1 hour.")
        let secondInstruction = RecipeInstruction(instruction: "Heat a lightly oiled griddle or frying pan over medium high heat. Pour or scoop the batter onto the griddle, using approximately 1/4 cup for each pancake. Brown on both sides and serve hot.")

        return Recipe(name: "Blueberry Pancakes", ingredients: ingredients, instructions: [firstInstruction, secondInstruction])
    }

}

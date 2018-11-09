//
//  PancakeRecipeService.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 10/31/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

final class RandomRecipeService: RecipeServiceType {

    func fetchRecipe() -> Recipe {
        switch Int.random(in: 0..<3) {
        case 0:
            return makePancakeRecipe()
        case 1:
            return makeIceRecipe()
        case 2:
            fallthrough
        default:
            return makeToastRecipe()
        }
    }

    private func makePancakeRecipe() -> Recipe {
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

    private func makeIceRecipe() -> Recipe {
        let ingredients = [
            RecipeIngredient(quantity: "2 cups", ingredient: "water"),
            RecipeIngredient(quantity: "2 tablespoons", ingredient: "extra water"),
            RecipeIngredient(quantity: "1", ingredient: "ice tray")
        ]

        let instructions = [
            RecipeInstruction(instruction: "Empty the ice cubes that are left in the trays (if there are any left) into the bin."),
            RecipeInstruction(instruction: "Take the trays over to the sink and fill them with cold water."),
            RecipeInstruction(instruction: "Place the water filled ice trays back in the freezer."),
            RecipeInstruction(instruction: "Replace the ice bin if you had to remove it."),
            RecipeInstruction(instruction: "Shut the door to the freezer."),
            RecipeInstruction(instruction: "Be sure to leave for around 4-6 hours at least to make sure it is frozen."),
            RecipeInstruction(instruction: "If you want to experiment, you can freeze things like fruit infused waters or juices.")
        ]

        return Recipe(name: "Ice Cubes", ingredients: ingredients, instructions: instructions)
    }

    private func makeToastRecipe() -> Recipe {
        let ingredients = [
            RecipeIngredient(quantity: "2 slices", ingredient: "bread"),
            RecipeIngredient(quantity: "2 tablespoons", ingredient: "butter"),
            RecipeIngredient(quantity: "At least 1", ingredient: "common sense")
        ]

        let instructions = [
            RecipeInstruction(instruction: "Take piece of bread in right or left hand."),
            RecipeInstruction(instruction: "With alternate hand, open toaster- NOTE: This step may vary depending on your toaster oven."),
            RecipeInstruction(instruction: "Place piece of bread in toaster oven."),
            RecipeInstruction(instruction: "Turn dial/knob determine the level of darkness to your desire"),
            RecipeInstruction(instruction: "Turn on toaster"),
            RecipeInstruction(instruction: "Wait."),
            RecipeInstruction(instruction: "Remove toast (no longer bread) from toaster over when the toasting of said toast is no longer toasting."),
            RecipeInstruction(instruction: "Place toast on surface of object of your choice."),
            RecipeInstruction(instruction: "Spread butter on toast."),
            RecipeInstruction(instruction: "🍞")
        ]

        return Recipe(name: "Toast", ingredients: ingredients, instructions: instructions)
    }

}

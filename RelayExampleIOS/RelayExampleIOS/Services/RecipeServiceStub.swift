//
//  RecipeServiceStub.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 10/31/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

final class RecipeServiceStub: RecipeServiceType {

    private let recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    func fetchRecipe() -> Recipe {
        return recipe
    }

}

//
//  RecipeIngredient.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 10/31/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

struct RecipeIngredient {

    let quantity: String?
    let ingredient: String

    init(quantity: String?, ingredient: String) {
        self.quantity = quantity
        self.ingredient = ingredient
    }

}

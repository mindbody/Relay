//
//  RecipeDataStore.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 10/31/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

final class RecipeDataStore: RecipeDataStoreType {

    private let service: RecipeServiceType

    init(service: RecipeServiceType) {
        self.service = service
    }

    func fetchViewModel() -> RecipeViewModel {
        let recipe = service.fetchRecipe()
        return RecipeViewModel(recipe: recipe)
    }

}

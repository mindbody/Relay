//
//  RecipeViewController.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 10/31/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import UIKit

final class RecipeViewController: UIViewController {

    @IBOutlet private weak var recipeNameLabel: UILabel!
    @IBOutlet private weak var ingredientsLabel: UILabel!
    @IBOutlet private weak var instructionsLabel: UILabel!
    var dataStore: RecipeDataStoreType?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let dataStore = dataStore else {
            fatalError("Need to set dataStore")
        }

        let viewModel = dataStore.fetchViewModel()
        configure(viewModel: viewModel)
    }

    private func configure(viewModel: RecipeViewModel) {
        recipeNameLabel.text = viewModel.recipeName
        ingredientsLabel.text = viewModel.formattedIngredients
        instructionsLabel.text = viewModel.formattedInstructions
    }


}


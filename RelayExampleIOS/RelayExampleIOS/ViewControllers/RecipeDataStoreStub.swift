//
//  RecipeDataStoreStub.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 10/31/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation

final class RecipeDataStoreStub: RecipeDataStoreType {

    private let viewModel: RecipeViewModel

    init(viewModel: RecipeViewModel) {
        self.viewModel = viewModel
    }

    func fetchViewModel() -> RecipeViewModel {
        return viewModel
    }

}

//
//  RelayUITestDependencyKeys.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 11/2/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation
import Relay

extension DependencyFactoryKey {

    static let testRecipeService = DependencyFactoryKey("RelayExampleIOSUITests.RecipeService")
    static let testRecipeDataStore = DependencyFactoryKey("RelayExampleIOSUITests.RecipeDataStore")

}

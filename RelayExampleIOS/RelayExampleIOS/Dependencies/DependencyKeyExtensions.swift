//
//  DependencyKeyExtensions.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 11/1/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation
import Relay

extension DependencyTypeKey {

    static let recipeService = DependencyTypeKey("RelayExampleIOS.RecipeServiceType")
    static let recipeDataStore = DependencyTypeKey("RelayExampleIOS.RecipeDataStoreType")

}

extension DependencyFactoryKey {

    static let recipeService = DependencyFactoryKey("RelayExampleIOS.RecipeService")
    static let recipeServiceStub = DependencyFactoryKey("RelayExampleIOS.RecipeServiceStub")
    static let recipeDataStore = DependencyFactoryKey("RelayExampleIOS.RecipeDataStore")
    static let recipeDataStoreStub = DependencyFactoryKey("RelayExampleIOS.RecipeDataStoreStub")

}

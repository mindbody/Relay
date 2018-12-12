//
//  DefaultDependencyTypeIndex.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 11/1/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation
import Relay

final class DefaultDependencyTypeIndex: DependencyTypeIndexable {

    let index: [DependencyTypeKey: Any.Type] = [
        .recipeService: RecipeServiceType.self,
        .recipeDataStore: RecipeDataStoreType.self
    ]

}

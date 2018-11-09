//
//  DefaultDependencyFactoryIndex.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 11/1/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation
import Relay

final class DefaultDependencyFactoryIndex: DependencyFactoryIndexable {

    let index: [DependencyFactoryKey : (DependencyContainer) -> Any] = DefaultDependencyFactoryIndex.makeDefaultFactories()

    private static func makeDefaultFactories() -> [DependencyFactoryKey: (DependencyContainer) -> Any] {
        let recipeServiceFactory: (DependencyContainer) -> Any = { _ in
            RandomRecipeService()
        }
        let recipeDataStoreFactory: (DependencyContainer) -> Any = { container in
            RecipeDataStore(service: container.resolve(RecipeServiceType.self))
        }

        return [
            .recipeService: recipeServiceFactory,
            .recipeDataStore: recipeDataStoreFactory
        ]
    }

}

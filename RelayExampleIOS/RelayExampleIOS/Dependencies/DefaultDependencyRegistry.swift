//
//  DefaultDependencyRegistry.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 10/31/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import Foundation
import Relay

final class DefaultDependencyRegistry: DependencyRegistryType {

    func registerDependencies() throws {
        DependencyContainer.global.register(RecipeServiceType.self) { _ in
            PancakeRecipeService()
        }
        DependencyContainer.global.register(RecipeDataStoreType.self, lifecycle: .transient) { container in
            RecipeDataStore(service: container.resolve())
        }
    }

}

//
//  AppDelegate.swift
//  RelayExampleIOS
//
//  Created by John Hammerlund on 10/31/18.
//  Copyright © 2018 MINDBODY. All rights reserved.
//

import UIKit
import Relay

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerDependencies()
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
        guard let controller = mainStoryboard.instantiateInitialViewController() as? RecipeViewController else {
            fatalError("Cannot find initial view controller")
        }

        controller.dataStore = DependencyContainer.global.resolve(RecipeDataStoreType.self)

        let mainWindow = UIWindow(frame: UIScreen.main.bounds)
        mainWindow.rootViewController = controller
        mainWindow.makeKeyAndVisible()

        window = mainWindow

        return true
    }

    private func registerDependencies() {
        do {
            let defaultRegistry = DefaultDependencyRegistry()
            try defaultRegistry.registerDependencies()

            #if DEBUG
            DynamicDependencyIndex.shared.add(DefaultDependencyTypeIndex())
            DynamicDependencyIndex.shared.add(DefaultDependencyFactoryIndex())
            DynamicDependencyIndex.shared.add(RelayUITestFactoryIndex())

            let argumentParsers: [ArgumentParser] = [
                InjectDependenciesArgumentParser()
            ]

            try CommandLine.parse(with: argumentParsers)
            #endif
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }

}


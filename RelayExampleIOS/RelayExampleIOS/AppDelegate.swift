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
        /// Dependency registration should be done immediately on application launch
        registerDependencies()

        let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
        guard let controller = mainStoryboard.instantiateInitialViewController() as? RecipeViewController else {
            fatalError("Cannot find initial view controller")
        }

        /// Dependency registration and resolution is done via type-mapping. If a registry has not yet mapped a specified type,
        /// then the application will crash.
        controller.dataStore = DependencyContainer.global.resolve(RecipeDataStoreType.self)

        let mainWindow = UIWindow(frame: UIScreen.main.bounds)
        mainWindow.rootViewController = controller
        mainWindow.makeKeyAndVisible()

        window = mainWindow

        return true
    }

    private func registerDependencies() {
        do {
            /// Start by registering all dependencies manually. Never depend on dynamic injection during app development;
            /// its purpose is to replace existing dependencies, not fulfill them.

            let defaultRegistry = DefaultDependencyRegistry()
            try defaultRegistry.registerDependencies()

            /// (Optional) Removing dynamic injection code from release builds reduces binary size and eliminates potentials
            /// for unwanted debug code being released to the public.

            #if DEBUG

            /// A DynamicDependencyIndex is responsible for staging dependencies to be accessed by a DynamicDependencyRegistry;
            /// however, they DO NOT actually register any dependencies.

            DynamicDependencyIndex.shared.add(DefaultDependencyTypeIndex())
            DynamicDependencyIndex.shared.add(DefaultDependencyFactoryIndex())
            DynamicDependencyIndex.shared.add(RelayUITestFactoryIndex())

            /// The primary entrypoint for dynamic injection is via command line arguments. This argument parser takes an optional
            /// DynamicDependencyIndex (defaults to `shared`) and provides them to a DynamicDependencyRegistry. From there, command
            /// line instructions are used to selectively register dependencies from the provided index.

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

//
//  AppDelegate.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 22/07/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var pokemonManager = PokemonManager()
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = createRootVC()
        
        return true
    }
    
    func createRootVC() -> UINavigationController {
        UINavigationController(
            rootViewController: PokedexVC(pokemoManager: pokemonManager)
        )
    }
}

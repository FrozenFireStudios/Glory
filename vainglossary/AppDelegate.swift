//
//  AppDelegate.swift
//  vainglossary
//
//  Created by Marcus Smith on 2/25/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var database: Database!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let apiKey = ProcessInfo.processInfo.environment["vgAPIKey"] ?? "" // App currently doesn't need this
        
        database = Database(madGloryAPIKey: apiKey)
        database.update { result in
            switch result {
            case .success:
                print("Database updated successfully")
            case .failure(let error):
                print("Database failed to update with error: \(error)")
            }
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        window?.tintColor = .tintColor
        window?.makeKeyAndVisible()
        
        let draftStrategyViewController = DraftStrategyViewController()
        let heroesViewController = HeroesViewController(database: database)
        let liveDraftViewController = LiveDraftIntroViewController(database: database)
        
        let heroesNavController = UINavigationController(rootViewController: heroesViewController)
        heroesNavController.navigationBar.barStyle = .black
        
        let tabController = UITabBarController()
        tabController.tabBar.barStyle = .black
        tabController.viewControllers = [
            draftStrategyViewController,
            heroesNavController,
            liveDraftViewController,
        ]
        
        window?.rootViewController = tabController
        
        return true
    }
}


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
        
        guard let apiKey = ProcessInfo.processInfo.environment["vgAPIKey"] else {
            fatalError("API Key required")
        }
        
        database = Database(madGloryAPIKey: apiKey)
//        database.madGloryService.makeRequest(request: MatchRequest(id: UUID(uuidString: "57045080-fba9-11e6-a758-0671096b3e30")!)) { (result) in
//            print("")
//        }
        
        database.madGloryService.makeRequest(request: MatchesRequest()) { (result) in
            print("")
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}


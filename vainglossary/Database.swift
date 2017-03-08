//
//  Database.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

class Database {
    private let stack: CoreDataStack = ResettingStack(objectModelName: "VainGlory", storeName: "vainglory.sqlite")
    let madGloryService: MadGloryService
    
    init(madGloryAPIKey: String) {
        madGloryService = MadGloryService(apiKey: madGloryAPIKey, baseURL: URL(string: "https://api.dc01.gamelockerapp.com/")!)
    }
    
    func characters() throws -> [Character] {
        return try stack.mainContext.performAndReturn { _ in
            let request = Character.request()
            return try request.execute()
        }
    }
}

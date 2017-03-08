//
//  ResettingStack.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

/// A Core Data stack that deletes its persistent store and recreates it if it is unable to migrate it.
class ResettingStack: CoreDataStack {
    
    //==========================================================================
    // MARK: Creation
    //==========================================================================
    
    private let objectModelName: String
    private let modelBundle: Bundle
    private let storeName: String
    private let options: [String: AnyObject]?
    var observerTokens: [NSObjectProtocol] = []
    
    init(objectModelName: String, modelBundle: Bundle = Bundle.main, storeName: String, options: [String: AnyObject]? = nil) {
        self.objectModelName = objectModelName
        self.modelBundle = modelBundle
        self.storeName = storeName
        self.options = options
    }
    
    deinit {
        removeAllObservers()
    }
    
    //==========================================================================
    // MARK: Stack
    //==========================================================================
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = self.modelBundle.url(forResource: self.objectModelName, withExtension: "momd")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let documentsURL = self.applicationDocumentsDirectory()
        let storeURL = documentsURL.appendingPathComponent(self.storeName)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: self.options)
        }
        catch {
            do {
                // If we are unable to create a persistent store, it's probably a migration error. Delete the store and try again
                if FileManager.default.fileExists(atPath: storeURL.path) {
                    try FileManager.default.removeItem(at: storeURL)
                }
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: self.options)
            }
            catch let storeError {
                fatalError("Unable to set up persistent store: \(storeError)")
            }
        }
        
        return coordinator
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return context
    }()
    
    //==========================================================================
    // MARK: Convenience
    //==========================================================================
    
    private func applicationDocumentsDirectory() -> URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        }
        catch {
            fatalError("Unable to access Documents Directory: \(error)")
        }
    }
    
    func entityDescriptionForName(name: String) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: name, in: mainContext)
    }
}

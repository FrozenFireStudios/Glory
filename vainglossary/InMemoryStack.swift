//
//  InMemoryStack.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

class InMemoryStack: CoreDataStack {
    //==========================================================================
    // MARK: Creation
    //==========================================================================
    
    private let objectModelName: String
    private let modelBundle: Bundle
    private let options: [String: AnyObject]?
    var observerTokens: [NSObjectProtocol] = []
    
    init(objectModelName: String, inBundle bundle: Bundle = Bundle.main, options: [String: AnyObject]? = nil) {
        self.objectModelName = objectModelName
        self.modelBundle = bundle
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
        
        let store: NSPersistentStore?
        do {
            store = try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: self.options)
        }
        catch {
            fatalError("Unable to load store: \(error)")
        }
        
        if (store == nil) {
            fatalError("Unable to load store")
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
}

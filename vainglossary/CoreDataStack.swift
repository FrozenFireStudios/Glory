//
//  CoreDataStack.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

//==========================================================================
// MARK: - Observer Token Store
//==========================================================================

protocol ObserverTokenStore: class {
    var observerTokens: [NSObjectProtocol] { get set }
    func addObserverToken(_ token: NSObjectProtocol)
    func removeAllObservers()
}

extension ObserverTokenStore {
    
    func addObserverToken(_ token: NSObjectProtocol) {
        observerTokens.append(token)
    }
    
    func removeAllObservers() {
        for observer in observerTokens {
            NotificationCenter.default.removeObserver(observer)
        }
        
        observerTokens = []
    }
}

//==========================================================================
// MARK: - Core Data Stack
//==========================================================================

protocol CoreDataStack: ObserverTokenStore {
    var mainContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }
    
    func setupContextNotifications()
}

extension CoreDataStack {
    func setupContextNotifications() {
        addObserverToken(NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave, object: mainContext, queue: nil) { [weak self] (note) -> Void in
            if let targetContext = self?.backgroundContext {
                targetContext.perform { () -> Void in
                    targetContext.mergeChanges(fromContextDidSave: note)
                }
            }
        })
        
        addObserverToken(NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave, object: backgroundContext, queue: nil) { [weak self] (note) -> Void in
            if let targetContext = self?.mainContext {
                targetContext.perform { () -> Void in
                    targetContext.mergeChanges(fromContextDidSave: note)
                }
            }
        })
    }
}

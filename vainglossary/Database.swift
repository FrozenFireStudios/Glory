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
    let gloryBackendService: GloryBackendService
    
    init(madGloryAPIKey: String) {
        madGloryService = MadGloryService(apiKey: madGloryAPIKey, baseURL: URL(string: "https://api.dc01.gamelockerapp.com/")!)
        gloryBackendService = GloryBackendService()
        stack.setupContextNotifications()
    }
    
    func update(completion: SuccessCompletion? = nil) {
        gloryBackendService.getData { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let data):
                do {
                    try strongSelf.save(type: Character.self, from: data.characters)
                    try strongSelf.save(type: Item.self, from: data.items)
                    try strongSelf.save(type: MatchUp.self, from: data.matchups)
                    completion?(.success())
                }
                catch {
                    completion?(.failure(error))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    private func save<T: IntIdentifiableEntity & JSONInstantiableEntity>(type: T.Type, from jsonDicts: [[String: Any]]) throws where T: NSManagedObject {
        var dictsByID = [Int64: [String: Any]]()
        
        jsonDicts.forEach { dict in
            if let id = dict["id"] as? Int64 {
                dictsByID[id] = dict
            }
        }
        
        let ids = Array(dictsByID.keys)
        
        guard ids.count == jsonDicts.count else {
            throw DatabaseUpdateError.missingIDs
        }
        
        try stack.backgroundContext.performAndThrow { (context) in
            let oldFR = T.request()
            oldFR.predicate = NSPredicate(format: "NOT (%K IN %@)", "id", ids)
            
            let oldObjects = try oldFR.execute()
            oldObjects.forEach { context.delete($0) }
            
            try ids.forEach { id in
                let object: T = try context.entity(withID: id)
                let jsonDict = dictsByID[id]!
                try object.update(from: jsonDict, in: context)
            }
            
            try context.save()
        }
    }
    
    func createCharacterResultsController() -> NSFetchedResultsController<Character> {
        let fr = Character.request()
        fr.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func createNewDraft() -> Draft {
        return Draft(context: stack.mainContext)
    }
}

enum DatabaseUpdateError: Error {
    case missingIDs
    case invalidItemName
}

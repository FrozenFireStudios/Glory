//
//  Entity.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

protocol Entity: class {
    static var entityName: String { get }
}

extension Entity where Self: NSManagedObject {
    static func request() -> NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: entityName)
    }
}

protocol IntIdentifiableEntity: Entity {
    var id: Int64 { get set }
}

protocol StringIdentifiableEntity: Entity {
    var id: String { get set }
}

extension NSManagedObjectContext {
    func entity<T: IntIdentifiableEntity>(withID id: Int64) throws -> T where T: NSManagedObject {
        let fr = T.request()
        fr.predicate = NSPredicate(format: "%K == %d", "id", id)
        
        let result = (try fr.execute()).first
        
        if let existingEntity = result {
            return existingEntity
        }
        
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as! T
        newEntity.id = id
        return newEntity
    }
    
    func entity<T: StringIdentifiableEntity>(withID id: String) throws -> T where T: NSManagedObject {
        let fr = T.request()
        fr.predicate = NSPredicate(format: "%K == %@", "id", id)
        
        let result = (try fr.execute()).first
        
        if let existingEntity = result {
            return existingEntity
        }
        
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as! T
        newEntity.id = id
        return newEntity
    }
}

protocol JSONInstantiableEntity {
    func update(from json: [String: Any], in context: NSManagedObjectContext) throws
}

enum JSONInstantiationError: LocalizedError {
    case invalidJSON(json: [String: Any])
    case wrongID(id: Any, expected: Any)
    case notFound(object: Any)
    
    var errorDescription: String? {
        switch self {
        case .invalidJSON(let json):
            return "Invalid JSON: \(json)"
        case .wrongID(let id, let expected):
            return "Wrong ID: \(id), expected: \(expected)"
        case .notFound(let object):
            return "Not found: \(object)"
        }
    }
}

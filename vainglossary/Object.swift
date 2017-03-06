//
//  Object.swift
//  vainglossary
//
//  Created by Marcus Smith on 2/26/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

protocol Object: class {
    var idString: String { get }
    static var objectType: ObjectType { get }
    static var entityName: String { get }
    func update(attributes: [String: Any])
    func update(relationships: [Relationship])
}

extension Object where Self: NSManagedObject {
    var id: UUID {
        return UUID(uuidString: idString)!
    }
    
    func createOrUpdate(from data: ObjectData, in context: NSManagedObjectContext) -> Self {
        fatalError("Do this") // TODO: This
    }
}

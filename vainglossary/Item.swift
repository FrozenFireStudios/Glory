//
//  Item+CoreDataClass.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject, IntIdentifiableEntity, JSONInstantiableEntity {
    static var entityName = "Item"
    
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var itemDescription: String
    @NSManaged var cost: Int16
    @NSManaged var tier: Int16
    
    @NSManaged private var typesString: String
    @NSManaged private var aliasesString: String
    
    func update(from json: [String: Any], in context: NSManagedObjectContext) throws {
        guard
            let id = json["id"] as? Int64,
            let name = json["name"] as? String,
            let itemDescription = json["description"] as? String,
            let cost = json["cost"] as? Int16,
            let tier = json["tier"] as? Int16,
            let typesArray = json["types"] as? [String],
            let aliasesArray = json["aliases"] as? [String]
            else {
                throw JSONInstantiationError.invalidJSON(json: json)
        }
        
        guard id == self.id else {
            throw JSONInstantiationError.wrongID(id: id, expected: self.id)
        }
        
        self.name = name
        self.itemDescription = itemDescription
        self.cost = cost
        self.tier = tier
        self.typesString = typesArray.joined(separator: ",")
        self.aliasesString = aliasesArray.joined(separator: ",")
    }
    
    var types: [String] {
        get {
            return typesString.components(separatedBy: ",")
        }
        set {
            typesString = newValue.joined(separator: ",")
        }
    }
    
    var aliases: [String] {
        get {
            return aliasesString.components(separatedBy: ",")
        }
        set {
            aliasesString = newValue.joined(separator: ",")
        }
    }
    
    
    @NSManaged var participants: Set<Participant>?
}

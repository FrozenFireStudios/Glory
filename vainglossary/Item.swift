//
//  Item+CoreDataClass.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject, Entity {
    static var entityName = "Item"
    
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var itemDescription: String
    @NSManaged var cost: Int16
    @NSManaged var tier: Int16
    
    @NSManaged private var typesString: String
    @NSManaged private var aliasesString: String
    
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

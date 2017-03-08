//
//  Participant+CoreDataClass.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

class Participant: NSManagedObject, Entity {
    static var entityName = "Participant"
    
    @NSManaged var id: String
    @NSManaged var playerName: String
    @NSManaged var won: Bool
    @NSManaged var kills: Int16
    @NSManaged var deaths: Int16
    @NSManaged var assists: Int16
    
    var kda: Float {
        return Float(kills + assists) / Float(deaths)
    }
    
    @NSManaged var character: Character
    @NSManaged var items: Set<Item>
    @NSManaged var match: Match
}

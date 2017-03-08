//
//  MatchUp+CoreDataClass.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

class MatchUp: NSManagedObject, Entity {
    static var entityName = "MatchUp"
    
    @NSManaged var againstValue: Int64
    @NSManaged var withValue: Int64
    @NSManaged var character: Character
    @NSManaged var otherCharacter: Character
}

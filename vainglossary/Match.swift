//
//  Match+CoreDataClass.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

class Match: NSManagedObject, Entity {
    static var entityName = "Match"
    
    @NSManaged var id: String
    @NSManaged var duration: Int64
    @NSManaged var date: NSDate
    @NSManaged var participants: Set<Participant>
}

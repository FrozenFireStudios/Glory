//
//  Relationship.swift
//  vainglossary
//
//  Created by Marcus Smith on 2/26/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation

struct Relationship {
    let type: ObjectType
    let id: UUID
    
    init?(dictionary: [String: Any]) {
        guard
            let idString = dictionary["id"] as? String,
            let id = UUID(uuidString: idString),
            let typeString = dictionary["type"] as? String,
            let type = ObjectType(rawValue: typeString)
            else {
                return nil
        }
        
        self.id = id
        self.type = type
    }
}

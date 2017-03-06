//
//  ObjectData.swift
//  vainglossary
//
//  Created by Marcus Smith on 2/25/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation

struct ObjectData {
    let id: UUID
    let type: ObjectType
    let attributes: [String: Any]
    let relationships: [Relationship]
    
    init?(dictionary: [String: Any]) {
        guard
            let idString = dictionary["id"] as? String,
            let id = UUID(uuidString: idString),
            let typeString = dictionary["type"] as? String,
            let type = ObjectType(rawValue: typeString),
            let attributes = dictionary["attributes"] as? [String: Any],
            let relationshipsDict = dictionary["relationships"] as? [String: Any]
            else {
                return nil
        }
        
        self.id = id
        self.type = type
        self.attributes = attributes
        
        let relationshipDicts = relationshipsDict.values.flatMap({ ($0 as? [String: Any])?["data"] as? [[String: Any]] }).flatMap({ $0 })
        self.relationships = relationshipDicts.flatMap({ Relationship(dictionary: $0) })
    }
}

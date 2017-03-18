//
//  MatchUp+CoreDataClass.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

class MatchUp: NSManagedObject, IntIdentifiableEntity, JSONInstantiableEntity {
    static var entityName = "MatchUp"
    
    @NSManaged var id: Int64
    @NSManaged var againstValue: Int64
    @NSManaged var withValue: Int64
    @NSManaged var character: Character
    @NSManaged var otherCharacter: Character
    
    func update(from json: [String : Any], in context: NSManagedObjectContext) throws {
        guard
            let id = json["id"] as? Int64,
            let characterName = json["character"] as? String,
            let otherCharacterName = json["otherCharacter"] as? String,
            let withValue = json["withValue"] as? Int64,
            let againstValue = json["againstValue"] as? Int64
            else {
                throw JSONInstantiationError.invalidJSON(json: json)
        }
        
        guard id == self.id else {
            throw JSONInstantiationError.wrongID(id: id, expected: self.id)
        }
        
        let fr = Character.request()
        fr.predicate = NSPredicate(format: "%K IN %@", "serverName", [characterName, otherCharacterName])
        let characters = try fr.execute()
        
        guard let character = characters.filter({ $0.name == characterName }).first else {
            throw JSONInstantiationError.notFound(object: characterName)
        }
        
        guard let otherCharacter = characters.filter({ $0.name == otherCharacterName }).first else {
            throw JSONInstantiationError.notFound(object: otherCharacterName)
        }
        
        self.againstValue = againstValue
        self.withValue = withValue
        self.character = character
        self.otherCharacter = otherCharacter
    }
}

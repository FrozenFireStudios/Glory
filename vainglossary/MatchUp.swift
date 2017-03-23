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
    @NSManaged var gamesAgainst: Int64
    @NSManaged var gamesAgainstWon: Int64
    @NSManaged var gamesWith: Int64
    @NSManaged var gamesWithWon: Int64
    @NSManaged var character: Character
    @NSManaged var otherCharacter: Character
    
    var withValue: Double {
        guard gamesWith > 0 else {
            return 0
        }
        
        return Double(gamesWithWon) / Double(gamesWith)
    }
    
    var againstValue: Double {
        guard gamesAgainst > 0 else {
            return 0.5
        }
        
        return Double(gamesAgainstWon) / Double(gamesAgainst)
    }
    
    func update(from json: [String : Any], in context: NSManagedObjectContext) throws {
        guard
            let id = json["id"] as? Int64,
            let characterName = json["character"] as? String,
            let otherCharacterName = json["otherCharacter"] as? String,
            let gamesAgainst = json["gamesAgainst"] as? Int64,
            let gamesAgainstWon = json["gamesAgainstWon"] as? Int64,
            let gamesWith = json["gamesWith"] as? Int64,
            let gamesWithWon = json["gamesWithWon"] as? Int64
            else {
                throw JSONInstantiationError.invalidJSON(json: json)
        }
        
        guard id == self.id else {
            throw JSONInstantiationError.wrongID(id: id, expected: self.id)
        }
        
        let fr = Character.request()
        fr.predicate = NSPredicate(format: "%K IN %@", "serverName", [characterName, otherCharacterName])
        let characters = try fr.execute()
        
        guard let character = characters.filter({ $0.serverName == characterName }).first else {
            throw JSONInstantiationError.notFound(object: characterName)
        }
        
        guard let otherCharacter = characters.filter({ $0.serverName == otherCharacterName }).first else {
            throw JSONInstantiationError.notFound(object: otherCharacterName)
        }
        
        self.gamesAgainst = gamesAgainst
        self.gamesAgainstWon = gamesAgainstWon
        self.gamesWith = gamesWith
        self.gamesWithWon = gamesWithWon
        self.character = character
        self.otherCharacter = otherCharacter
    }
}

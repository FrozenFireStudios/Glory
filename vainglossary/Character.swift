//
//  Character+CoreDataClass.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

class Character: NSManagedObject, IntIdentifiableEntity, JSONInstantiableEntity {
    static var entityName = "Character"
    
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var serverName: String
    
    @NSManaged private var buildsString: String
    @NSManaged private var rolesString: String
    
    var builds: [Build] {
        get {
            return buildsString.components(separatedBy: ",").flatMap { Build(rawValue: $0) }
        }
        set {
            buildsString = newValue.map({ $0.rawValue }).joined(separator: ",")
        }
    }
    
    var roles: [Role] {
        get {
            return rolesString.components(separatedBy: ",").flatMap { Role(rawValue: $0) }
        }
        set {
            rolesString = newValue.map({ $0.rawValue }).joined(separator: ",")
        }
    }
    
    func update(from json: [String : Any], in context: NSManagedObjectContext) throws {
        guard
            let id = json["id"] as? Int64,
            let name = json["name"] as? String,
            let serverName = json["serverName"] as? String,
            let buildsArray = json["builds"] as? [String],
            let rolesArray = json["roles"] as? [String]
            else {
                throw JSONInstantiationError.invalidJSON(json: json)
        }
        
        guard id == self.id else {
            throw JSONInstantiationError.wrongID(id: id, expected: self.id)
        }
        
        self.name = name
        self.serverName = serverName
        self.buildsString = buildsArray.joined(separator: ",")
        self.rolesString = rolesArray.joined(separator: ",")
    }
    
    @NSManaged var matchUps: Set<MatchUp>?
    @NSManaged var reverseMatchUps: Set<MatchUp>?
    @NSManaged var participants: Set<Participant>?
    
    func bestAgainst(count: Int = 3) throws -> [Character] {
        let sorted = (matchUps ?? []).sorted(by: { $0.0.againstValue > $0.1.againstValue })
        return sorted.prefix(count).map { $0.otherCharacter }
    }
    
    func bestCounters(count: Int = 3) throws -> [Character] {
        let sorted = (matchUps ?? []).sorted(by: { $0.0.againstValue < $0.1.againstValue })
        return sorted.prefix(count).map { $0.otherCharacter }
    }
    
    func bestWith(count: Int = 3) throws -> [Character] {
        let sorted = (matchUps ?? []).sorted(by: { $0.0.withValue > $0.1.withValue })
        return sorted.prefix(count).map { $0.otherCharacter }
    }
    
    func worstWith(count: Int = 3) throws -> [Character] {
        let sorted = (matchUps ?? []).sorted(by: { $0.0.withValue < $0.1.withValue })
        return sorted.prefix(count).map { $0.otherCharacter }
    }
}

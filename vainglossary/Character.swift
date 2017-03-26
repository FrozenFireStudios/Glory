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
    @NSManaged var favorite: Bool
    
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
    
    var selfMatchup: MatchUp? {
        return matchUps?.filter { $0.otherCharacter == self }.first
    }
    
    func bestAgainst(count: Int = 3) -> [Character] {
        let sorted = (matchUps ?? []).sorted(by: { $0.againstValue > $1.againstValue })
        return sorted.prefix(count).map { $0.otherCharacter }
    }
    
    func bestCounters(count: Int = 3) -> [Character] {
        let sorted = (matchUps ?? []).sorted(by: { $0.againstValue < $1.againstValue })
        return sorted.prefix(count).map { $0.otherCharacter }
    }
    
    func bestWith(count: Int = 3) -> [Character] {
        let sorted = (matchUps ?? []).sorted(by: { $0.withValue > $1.withValue })
        return sorted.prefix(count).map { $0.otherCharacter }
    }
    
    func worstWith(count: Int = 3) -> [Character] {
        let sorted = (matchUps ?? []).sorted(by: { $0.withValue < $1.withValue })
        return sorted.prefix(count).map { $0.otherCharacter }
    }
    
    func overallValue(with: [Character], against: [Character], banned: [Character]) -> Double {
        guard let allMatchups = matchUps, let selfMatchup = selfMatchup  else {
            return 0
        }
        
        var allowedBuilds: Set<Build> = [.weapon, .crystal, .support]
        var allowedRoles: Set<Role> = [.carry, .jungler, .captain]
        
        // Remove any builds taken by non-flexible characters
        with.filter { $0.builds.count == 1 }.forEach { character in
            let takenBuild = character.builds.first!
            allowedBuilds.remove(takenBuild)
        }
        
        // Remove any roles taken by non-flexible characters
        with.filter { $0.roles.count == 1 }.forEach { character in
            let takenRole = character.roles.first!
            allowedRoles.remove(takenRole)
        }
        
        if with.count == 2 {
            // If no teammates can fullfil a build, that build is required
            if let necessaryBuild = allowedBuilds.filter({ !with[0].builds.contains($0) && !with[1].builds.contains($0) }).first {
                allowedBuilds = [necessaryBuild]
            }
            
            // If no teammates can fullfil a role, that role is required
            if let necessaryRole = allowedRoles.filter({ !with[0].roles.contains($0) && !with[1].roles.contains($0) }).first {
                allowedRoles = [necessaryRole]
            }
        }
        
        let canFullfillAllowedBuild = builds.reduce(false, { $0 || allowedBuilds.contains($1) })
        let canFullfillAllowedRole = roles.reduce(false, { $0 || allowedRoles.contains($1) })
        
        guard canFullfillAllowedBuild && canFullfillAllowedRole else {
            return 0
        }
        
        let totalNumberOfMatches = selfMatchup.gamesWith
        let totalWins = selfMatchup.gamesWithWon
        
        guard totalNumberOfMatches > 0 else {
            return 0
        }
        
        let bannedMatchups = allMatchups.filter { banned.contains($0.otherCharacter) }
        
        let bannedCount = banned.count
        let bannedTotal = bannedMatchups.reduce(0) { $0 + $1.gamesAgainst }
        let bannedWins = bannedMatchups.reduce(0) { $0 + $1.gamesAgainstWon }
        
        let bannedWeight = bannedCount > 1 ? 0.6 : 1
        let banAdjustedWins: Double = Double(totalWins) - (Double(bannedWins) * bannedWeight)
        let banAdjustedTotal: Double = Double(totalNumberOfMatches) - (Double(bannedTotal) * bannedWeight)
        
        let banValue = banAdjustedTotal > 0 ? banAdjustedWins / banAdjustedTotal : 0
        var values: [Double] = [banValue]
        
        if against.count > 0 {
            let avgAgainstCount = allMatchups.reduce(0, { $0 + Double($1.gamesAgainst) }) / Double(allMatchups.count)
            let validAgainstMatchups = allMatchups.filter { against.contains($0.otherCharacter) }.filter { Double($0.gamesAgainst) > (avgAgainstCount * 0.1) && $0.gamesAgainst > 0 }
            validAgainstMatchups.forEach { values.append(Double($0.gamesAgainstWon) / Double($0.gamesAgainst)) }
        }
        
        
        if with.count > 0 {
            let avgWithCount = allMatchups.reduce(0, { $0 + Double($1.gamesAgainst) }) / Double(allMatchups.count)
            let validWithMatchups = allMatchups.filter { with.contains($0.otherCharacter) }.filter { $0.gamesWith > 0 }
            validWithMatchups.forEach { matchup in
                if Double(matchup.gamesWith) > (avgWithCount * 0.2) {
                    values.append(Double(matchup.gamesWithWon) / Double(matchup.gamesWith))
                } else {
                    values.append(0)
                }
            }
        }
        
        var averageValue = values.reduce(0, +) / Double(values.count)
        
        // Weight early picks differently for better drafting strategy
        if banned.count == 2 && with.count < 2 {
            // Give priority to captain and then carry picks
            if allowedRoles.contains(.captain) && roles.contains(.captain) {
                averageValue = min(1, averageValue + 0.1)
            }
            else if allowedRoles.contains(.carry) && roles.contains(.carry) {
                averageValue = min(1, averageValue + 0.05)
            }
            
            // Weight more flexible picks more highly
            if with.count == 0 || (with.count == 1 && against.count == 1) {
                let options = roles.count + builds.count
                let bonus = max(0, Double(options) - 2)
                averageValue = min(1, averageValue + bonus)
            }
        }
        
        return averageValue
    }
    
    class func randomThree(in context: NSManagedObjectContext) -> [Character] {
        let characters: [Character] = (try? context.performAndReturn(code: { _ in
            let fr = Character.request()
            let chars = try fr.execute()
            
            let topIndex = chars.count - 2
            let startPos = Int(arc4random_uniform(UInt32(topIndex)))
            let endPos = startPos + 2
            
            return Array(chars[startPos...endPos])
        })) ?? []
        
        return characters
    }
}

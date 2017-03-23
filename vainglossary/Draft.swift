//
//  Draft.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/18/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

class Draft {
    let context: NSManagedObjectContext
    private(set) var teamABan: Character?
    private(set) var teamBBan: Character?
    private(set) var teamAPick1: Character?
    private(set) var teamBPick1: Character?
    private(set) var teamBPick2: Character?
    private(set) var teamAPick2: Character?
    private(set) var teamAPick3: Character?
    private(set) var teamBPick3: Character?
    
    private(set) var isNextPickTeamA = true
    
    var bans: [Character] {
        return [teamABan, teamBBan].flatMap {$0}
    }
    
    var teamAPicks: [Character] {
        return [teamAPick1, teamAPick2, teamAPick3].flatMap {$0}
    }
    
    var teamBPicks: [Character] {
        return [teamBPick1, teamBPick2, teamBPick3].flatMap {$0}
    }
    
    var allCharacters: [Character] {
        if let characters = _allCharacters {
            return characters
        }
        
        _allCharacters = try? fetchAllCharacters()
        return _allCharacters ?? []
    }
    
    /// All Heroes not already picked, banned, or recommended
    var remainingCharacters: [Character] {
        let characters = Set<Character>(allCharacters)
        let takenCharacters = Set<Character>(pickedCharacters + nextRecommendations)
        
        return characters.subtracting(takenCharacters).sorted(by: { $0.name < $1.name })
    }
    
    private var pickedCharacters: [Character] {
        return bans + teamAPicks + teamBPicks
    }
    
    private var notPickedCharacters: [Character] {
        let characters = Set<Character>(allCharacters)
        let takenCharacters = Set<Character>(pickedCharacters)
        
        return characters.subtracting(takenCharacters).sorted(by: { $0.name < $1.name })
    }
    
    private var nextRecommendations = [Character]()
    private var _allCharacters: [Character]?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        generateNextRecommendations()
    }
    
    func setNextCharacter(_ character: Character) {
        if teamABan == nil {
            teamABan = character
            isNextPickTeamA = false
        }
        else if teamBBan == nil {
            teamBBan = character
            isNextPickTeamA = true
        }
        else if teamAPick1 == nil {
            teamAPick1 = character
            isNextPickTeamA = false
        }
        else if teamBPick1 == nil {
            teamBPick1 = character
            isNextPickTeamA = false
        }
        else if teamBPick2 == nil {
            teamBPick2 = character
            isNextPickTeamA = true
        }
        else if teamAPick2 == nil {
            teamAPick2 = character
            isNextPickTeamA = true
        }
        else if teamAPick3 == nil {
            teamAPick3 = character
            isNextPickTeamA = false
        }
        else if teamBPick3 == nil {
            teamBPick3 = character
            isNextPickTeamA = false
        }
        
        generateNextRecommendations()
    }
    
    func removeLastPick() {
        if teamBPick3 != nil {
            teamBPick3 = nil
            isNextPickTeamA = false
        }
        else if teamAPick3 != nil {
            teamAPick3 = nil
            isNextPickTeamA = true
        }
        else if teamAPick2 != nil {
            teamAPick2 = nil
            isNextPickTeamA = true
        }
        else if teamBPick2 != nil {
            teamBPick2 = nil
            isNextPickTeamA = false
        }
        else if teamBPick1 != nil {
            teamBPick1 = nil
            isNextPickTeamA = false
        }
        else if teamAPick1 != nil {
            teamAPick1 = nil
            isNextPickTeamA = true
        }
        else if teamBBan != nil {
            teamBBan = nil
            isNextPickTeamA = false
        }
        else if teamABan != nil {
            teamABan = nil
            isNextPickTeamA = true
        }
        
        generateNextRecommendations()
    }
    
    func recommendationsForNextPick(count: Int = 3) -> [Character] {
        return Array(nextRecommendations.prefix(count))
    }
    
    private func fetchAllCharacters() throws -> [Character] {
        return try self.context.performAndReturn { (context) in
            let fr = Character.request()
            return try fr.execute()
        }
    }
    
    private func generateNextRecommendations() {
        // If the draft is full there are no more recommendations
        guard teamBPick3 == nil else {
            nextRecommendations = []
            return
        }
        
        let team = isNextPickTeamA ? teamAPicks : teamBPicks
        let otherTeam = isNextPickTeamA ? teamBPicks : teamAPicks
        
        nextRecommendations = notPickedCharacters
            .sorted { $0.overallValue(with: team, against: otherTeam, banned: bans) > $1.overallValue(with: team, against: otherTeam, banned: bans) }
    }
    
    private func selfMatchups() throws -> [MatchUp] {
        return try context.performAndReturn { (context) in
            let fr = MatchUp.request()
            fr.predicate = NSPredicate(format: "%K == %K", "character", "otherCharacter")
            return try fr.execute()
        }
    }
}

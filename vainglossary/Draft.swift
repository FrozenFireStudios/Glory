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
    var teamABan: Character?
    var teamBBan: Character?
    var teamAPick1: Character?
    var teamBPick1: Character?
    var teamBPick2: Character?
    var teamAPick2: Character?
    var teamAPick3: Character?
    var teamBPick3: Character?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func setNextCharacter(_ character: Character) {
        if teamABan == nil {
            teamABan = character
        }
        else if teamBBan == nil {
            teamBBan = character
        }
        else if teamAPick1 == nil {
            teamAPick1 = character
        }
        else if teamBPick1 == nil {
            teamBPick1 = character
        }
        else if teamBPick2 == nil {
            teamBPick2 = character
        }
        else if teamAPick2 == nil {
            teamAPick2 = character
        }
        else if teamAPick3 == nil {
            teamAPick3 = character
        }
        else if teamBPick3 == nil {
            teamBPick3 = character
        }
    }
    
    func recommendationsForNextPick() -> [Character] {
        // TODO: Actually do this part
        return Character.randomThree(in: context)
    }
}

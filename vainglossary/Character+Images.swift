//
//  Character+Images.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/20/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation

extension Character {
    var smallIconName: String {
        return name.lowercased() + "-icon"
    }
    
    var largeIconName: String {
        return name.lowercased()
    }
}

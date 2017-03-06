//
//  MatchRequest.swift
//  vainglossary
//
//  Created by Marcus Smith on 2/25/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation

class MatchRequest: VainGloryRequest {
    init(id: UUID) {
        super.init(pathComponents: ["matches", id])
    }
}

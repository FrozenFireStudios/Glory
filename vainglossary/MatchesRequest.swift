//
//  MatchRequest.swift
//  vainglossary
//
//  Created by Marcus Smith on 2/25/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation

class MatchesRequest: VainGloryRequest {
    var playerNames: [String]?
    var limit: Int = 50
    var offset: Int = 0
    
    init(playerNames: [String]? = nil) {
        super.init(pathComponents: ["matches"])
        self.playerNames = playerNames
    }
    
    override func generateQueryItems() -> [URLQueryItem] {
        var queryItems = super.generateQueryItems()
        
//        queryItems.append(URLQueryItem(name: "page[limit]", value: "\(limit)"))
//        queryItems.append(URLQueryItem(name: "page[offset]", value: "\(offset)"))
        queryItems.append(URLQueryItem(name: "filter[createdAt-start]", value: "2017-03-01T00:00:00Z"))
        
        if let playerNames = playerNames {
            queryItems.append(URLQueryItem(name: "filter[playerNames]", value: playerNames.joined(separator: ",")))
        }
        
        return queryItems
    }
}

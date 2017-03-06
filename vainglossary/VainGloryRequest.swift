//
//  VainGloryRequest.swift
//  vainglossary
//
//  Created by Marcus Smith on 2/25/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation

class VainGloryRequest {
    private let pathComponents: [URLPathComponent]
    var shard: String = "na"
    
    init(pathComponents: [URLPathComponent]) {
        self.pathComponents = pathComponents
    }
    
    func generateQueryItems() -> [URLQueryItem] {
        return []
    }
    
    final func urlRequest(fromBaseURL baseURL: URL) -> URLRequest {
        let shardComponents: [URLPathComponent] = ["shards", shard]
        let url = baseURL.appendingPathComponents(shardComponents + pathComponents)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = generateQueryItems()
        return URLRequest(url: urlComponents.url!)
    }
    
    final func parseJSON(_ jsonDict: [String: Any]) throws -> (objects: [ObjectData], included: [ObjectData]) {
        if let errorDicts = jsonDict["errors"] as? [[String: Any]] {
            let vgErrors = errorDicts.map { VainGloryError(dictionary: $0) }
            throw VainGloryRequestError.receivedErrors(vgErrors)
        }
        
        var objects: [ObjectData] = []
        
        if let dataDict = jsonDict["data"] as? [String: Any], let data = ObjectData(dictionary: dataDict) {
            objects = [data]
        }
        else if let dataDicts = jsonDict["data"] as? [[String: Any]] {
            let validDatas = dataDicts.flatMap { ObjectData(dictionary: $0) }
            
            guard validDatas.count == dataDicts.count else {
                throw VainGloryRequestError.invalidJSON(jsonDict)
            }
            
            objects = validDatas
        }
        else {
            throw VainGloryRequestError.invalidJSON(jsonDict)
        }
        
        guard let includedDicts = jsonDict["included"] as? [[String: Any]] else {
            throw VainGloryRequestError.invalidJSON(jsonDict)
        }
        
        let validIncludedObjects = includedDicts.flatMap { ObjectData(dictionary: $0) }
        
        guard validIncludedObjects.count == includedDicts.count else {
            throw VainGloryRequestError.invalidJSON(jsonDict)
        }
        
        return (objects, validIncludedObjects)
    }
}

enum VainGloryRequestError: Error {
    case invalidJSON([String: Any])
    case receivedErrors([Error])
}

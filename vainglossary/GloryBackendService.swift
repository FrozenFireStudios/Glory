//
//  GloryBackendService.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/17/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation

class GloryBackendService {
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    @discardableResult
    func getData(completion: @escaping Completion<(characters: [[String: Any]], items: [[String: Any]], matchups: [[String: Any]])>) -> URLSessionDataTask {
        let url = URL(string: "https://glory-backend.herokuapp.com/data")!
        let request = URLRequest(url: url)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(GloryBackendError.noData))
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard
                    let jsonDict = jsonObject as? [String: Any],
                    let characters = jsonDict["characters"] as? [[String: Any]],
                    let items = jsonDict["items"] as? [[String: Any]],
                    let matchups = jsonDict["matchups"] as? [[String: Any]]
                    else {
                        completion(.failure(GloryBackendError.invalidJSON(jsonObject)))
                        return
                }
                
                completion(.success(characters: characters, items: items, matchups: matchups))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
        return dataTask
    }
}

enum GloryBackendError: Error {
    case noData
    case invalidJSON(Any)
}

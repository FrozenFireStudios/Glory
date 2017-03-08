//
//  VainGloryNetworkingService.swift
//  vainglossary
//
//  Created by Marcus Smith on 2/25/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation

class MadGloryService {
    private let apiKey: String
    private let baseURL: URL
    private let session: URLSession
    
    init(apiKey: String, baseURL: URL) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    @discardableResult
    func makeRequest(request: VainGloryRequest, completion: @escaping Completion<(objects: [ObjectData], included: [ObjectData])>) -> URLSessionDataTask {
        var urlRequest = request.urlRequest(fromBaseURL: baseURL)
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("semc-vainglory", forHTTPHeaderField: "X-TITLE-ID")
        urlRequest.addValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        print(urlRequest.url?.absoluteString ?? "")
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                // TODO: Check for 429 status code and retry response later
                completion(.failure(VainGloryNetworkingError.noData))
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard let jsonDict = jsonObject as? [String: Any] else {
                    completion(.failure(VainGloryNetworkingError.invalidJSON(jsonObject)))
                    return
                }
                
                print(jsonDict)
                
                let result = try request.parseJSON(jsonDict)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
        return dataTask
    }
}

enum VainGloryNetworkingError: Error {
    case noData
    case invalidJSON(Any)
    case invalidResponse(HTTPURLResponse)
    case receivedErrors([VainGloryError])
}

struct VainGloryError: Error {
    let title: String
    let description: String?
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "Unknown"
        description = dictionary["description"] as? String
    }
}

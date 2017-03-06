//
//  URLPathComponent.swift
//  vainglossary
//
//  Created by Marcus Smith on 2/25/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation

protocol URLPathComponent {
    var urlPathComponent: String { get }
}

extension URL {
    func appendingPathComponents(_ pathComponents: [URLPathComponent]) -> URL {
        let path = pathComponents.map({ $0.urlPathComponent }).joined(separator: "/")
        return appendingPathComponent(path)
    }
}

extension String: URLPathComponent {
    var urlPathComponent: String {
        guard let path = self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            fatalError("Invalid URL Path component: \(self)")
        }
        
        return path
    }
}

extension UUID: URLPathComponent {
    var urlPathComponent: String {
        return uuidString.lowercased()
    }
}

extension Int: URLPathComponent {
    var urlPathComponent: String {
        return "\(self)"
    }
}

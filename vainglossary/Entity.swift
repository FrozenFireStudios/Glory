//
//  Entity.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

protocol Entity: class {
    static var entityName: String { get }
}

extension Entity where Self: NSManagedObject {
    static func request() -> NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: entityName)
    }
}

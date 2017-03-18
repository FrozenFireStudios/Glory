//
//  NSManagedObjectContext+PerformAndReturn.swift
//  vainglossary
//
//  Created by Marcus Smith on 3/7/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func performAndReturn<T>(code: @escaping (NSManagedObjectContext) throws -> T) throws -> T {
        var returnValue: T?
        var errorToThrow: Error?
        
        performAndWait {
            do {
                returnValue = try code(self)
            }
            catch {
                errorToThrow = error
            }
        }
        
        if let error = errorToThrow {
            throw error
        }
        
        return returnValue!
    }
    
    func performAndThrow(code: @escaping (NSManagedObjectContext) throws -> Void) throws {
        var errorToThrow: Error?
        
        performAndWait {
            do {
                try code(self)
            }
            catch {
                errorToThrow = error
            }
        }
        
        if let error = errorToThrow {
            throw error
        }
    }
}

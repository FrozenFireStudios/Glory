//
//  Result.swift
//  vainglossary
//
//  Created by Marcus Smith on 2/25/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

typealias Completion<T> = (Result<T>) -> Void

typealias SuccessResult = Result<Void>
typealias SuccessCompletion = (SuccessResult) -> Void

//
//  Result.swift
//  BikeProvider
//
//  Created by Pete Smith on 02/04/2018.
//  Copyright © 2018 Pete Smith. All rights reserved.
//

import Foundation

/// Enum type which encapsulates the result of an operation which can either succeed or fail
///
/// - success: Success case, with associated value of type Value
/// - failure: Failure case, with associated value of type Error
public enum Result<Value> {
    case success(Value)
    case failure(Error)
}

//
//  Result.swift
//  BikeProvider
//
//  Created by Pete Smith on 02/04/2018.
//  Copyright © 2018 Pete Smith. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

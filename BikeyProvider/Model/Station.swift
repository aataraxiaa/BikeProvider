//
//  BikeStation.swift
//  BikeyGo
//
//  Created by Pete Smith on 31/05/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import CoreLocation

/**
 *  Bike Station model
 */
public struct Station {
    
    let name: String
    let bikes: Int
    let spaces: Int
    let location: CLLocation
    let lastUpdated: NSDate
}

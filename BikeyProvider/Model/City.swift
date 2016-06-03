//
//  City.swift
//  BikeyGo
//
//  Created by Pete Smith on 31/05/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import CoreLocation

/**
 *  City model
 */
public struct City {
    
    let name: String
    let href: String
    let location: CLLocation
    var stations = [Station]()
    
    init(name: String, href: String, location: CLLocation) {
        self.name = name
        self.href = href
        self.location = location
    }
}

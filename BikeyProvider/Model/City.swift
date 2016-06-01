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
    let href: String
    let location: CLLocation
    var stations = [Station]()
    
    init(href: String, location: CLLocation) {
        self.href = href
        self.location = location
    }
}

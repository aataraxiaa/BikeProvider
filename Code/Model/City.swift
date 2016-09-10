//
//  City.swift
//  BikeyGo
//
//  Created by Pete Smith on 31/05/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import CoreLocation

/**
 ### City
 
 A City represents a geographical city which has available bike share information
 */
public struct City {
    
    public let name: String
    public let url: String
    public let location: CLLocation
    
    public init(name: String, url: String, location: CLLocation) {
        self.name = name
        self.url = url
        self.location = location
    }
}

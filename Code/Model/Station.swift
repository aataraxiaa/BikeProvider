//
//  BikeStation.swift
//  BikeyGo
//
//  Created by Pete Smith on 31/05/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import CoreLocation

/**
 ### Station
 
 A Station represents a bike share station.
 
 It has associated bikes & spaces
 */
public struct Station {
    
    public let id: String
    public let name: String
    public let bikes: Int
    public let spaces: Int
    public let location: CLLocation
    public let lastUpdated: String
    public let sellsTickets: Bool
}

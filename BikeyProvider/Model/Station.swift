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
    
    public let id: String
    public let name: String
    public let bikes: Int
    public let spaces: Int
    public let location: CLLocation
    public let lastUpdated: String
    public let sellsTickets: Bool
    public var distance = "Unknown"
    
    public mutating func distanceFromLocation(currentLocation: CLLocation) {
        
        let distance = currentLocation.distanceFromLocation(location)
        
        self.distance = (distance < 500 ? String.localizedStringWithFormat(NSLocalizedString("bikey.bikeStation.distance.metresAway", comment: "%i M AWAY"), Int(round(distance))) : String.localizedStringWithFormat(NSLocalizedString("bikey.bikeStation.distance.kmAway", comment: "%i KM AWAY"), Int(round(distance/1000))))
    }
}

//
//  Created by Pete Smith
//  http://www.petethedeveloper.com
//
//
//  License
//  Copyright © 2016-present Pete Smith
//  Released under an MIT license: http://opensource.org/licenses/MIT
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

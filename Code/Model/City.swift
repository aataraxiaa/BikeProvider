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
 ### City
 
 A City represents a geographical city which has available bike share information
 */
public struct City: Decodable {
    
    // MARK: - Internal types
    
    public struct Location: Decodable {
        
        public let name: String
        public let latitude: Double
        public let longitude: Double
        
        public var coordinates: CLLocation {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        
        enum CodingKeys: String, CodingKey {
            case name = "city"
            case latitude
            case longitude
        }
    }
    
    // MARK: - Properties (Public)
    
    public let href: String
    public let location: Location
}

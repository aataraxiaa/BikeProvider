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

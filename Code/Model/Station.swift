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
public struct Station: Decodable {
    
    // MARK: - Internal types
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case bikes = "free_bikes"
        case spaces = "empty_slots"
        case latitude
        case longitude
        case lastUpdated = "timestamp"
        case extra
    }
    
    public struct Extra: Decodable {
        
        // MARK: - Internal types
        
        enum CodingKeys: String, CodingKey {
            case banking
            case installed
        }
        
        // MARK: - Properties (Public)
        public let banking: Bool
        public let installed: Bool
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            banking = (try? values.decode(Bool.self, forKey: .banking)) ?? true
            installed = (try? values.decode(Bool.self, forKey: .installed)) ?? true
        }
    }
    
    // MARK: - Properties (Public)
    
    public let id: String
    public let name: String
    public let bikes: Int
    public let spaces: Int
    public let latitude: Double
    public let longitude: Double
    public let lastUpdated: String
    public let extra: Extra
    
    public var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

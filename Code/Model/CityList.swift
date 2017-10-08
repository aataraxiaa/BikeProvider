//
//  Network.swift
//  BikeProvider
//
//  Created by Pete Smith on 28/06/2017.
//

import Foundation

public struct CityList: Codable {
    
    public let cities: [City]
    
    public init(cities: [City]) {
        self.cities = cities
    }
    
    enum CodingKeys: String, CodingKey {
        case cities = "networks"
    }
}

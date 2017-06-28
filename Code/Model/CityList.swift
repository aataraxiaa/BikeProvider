//
//  Network.swift
//  BikeProvider
//
//  Created by Pete Smith on 28/06/2017.
//

import Foundation

struct CityList: Decodable {
    
    let cities: [City]
    
    enum CodingKeys: String, CodingKey {
        case cities = "networks"
    }
}

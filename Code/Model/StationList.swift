//
//  StationList.swift
//  BikeProvider
//
//  Created by Pete Smith on 28/06/2017.
//  Copyright © 2017 Pete Smith. All rights reserved.
//

import Foundation

struct StationList: Decodable {
    
    struct Network: Decodable {
        let stations: [Station]
    }
    
    let network: Network
}

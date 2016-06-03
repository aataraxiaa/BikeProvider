//
//  StationProvider.swift
//  BikeyGo
//
//  Created by Pete Smith on 31/05/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import Foundation
import CoreLocation

public struct StationProvider {
    
    /**
     Get a cities stations
     
     - parameter href:    The city-specific url suffix
     - parameter success: Success closure
     - parameter failure: Failure closure
     */
    static public func getStations(href: String, success: (([Station]?) -> Void), failure: (() -> Void)) -> Void {
        
        // Use our api client to fetch the station information
        APIClient.get(href, completion: { (resultSuccess, result) in
            if resultSuccess {
                
                var stationCollection: [Station]?
                
                if let json = result, network = json["network"] as? [String: AnyObject], stations = network["stations"] as? [[String: AnyObject]] {
                    
                    stationCollection = [Station]()
                    
                    for station in stations {
                        if let stationId = station["id"] as? String {
                            
                            if let bikes = station["free_bikes"] as? Int, slots = station["empty_slots"] as? Int, lastUpdated = station["timestamp"] as? String, latitude = station["latitude"] as? Double,
                                longitude = station["longitude"] as? Double, name = station["name"] as? String {
                                
                                var installed = true, sellsTickets = true
                                
                                if let extra = station["extra"] as? [String:AnyObject] {
                                    if let active = extra["installed"] as? Bool {
                                        installed = active
                                    }
                                    
                                    if let banking = extra["banking"] as? Bool {
                                        sellsTickets = banking
                                    }
                                }
                                
                                // Only add bike stations that are 'Installed' - i.e that are actually present and active
                                if installed {
                                    
                                    // TODO: CREATE STATION AND PARSE NAME
                                    let location = CLLocation(latitude: latitude, longitude: longitude)
                                    let station = Station(id: stationId, name: name, bikes: bikes, spaces: slots, location: location, lastUpdated: lastUpdated)
                                    
                                    // Add to stations collection
                                    stationCollection?.append(station)
                                }
                            }
                        }
                    }
                    
                    success(stationCollection)
                } else {
                    failure()
                }
                
            } else {
                failure()
            }
        })
    }
    
    private static func parseStationName(inout station: Station) {

    }
}

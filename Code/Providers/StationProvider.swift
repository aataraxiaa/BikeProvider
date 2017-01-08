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
 ### StationProvider
 
 Provides methods for fetching the nearest bike stations for a specified city
 */
public struct StationProvider {
    
    /**
     Get a cities stations
     
     - parameter href:    The city-specific url suffix
     - parameter success: Success closure
     - parameter failure: Failure closure
     */
    static public func stations(fromCityURL url: String, onSuccess success: @escaping (([Station]) -> Void), onFailure failure: @escaping ((_ error: Error?) -> Void)) -> Void {
        
        let url = Constants.API.baseURL+url+Constants.API.requestOptions
        
        APIClient.get(from: url, withSuccess: { (result) in
                
            if let json = result, let network = json["network"] as? [String: AnyObject], let stations = network["stations"] as? [[String: AnyObject]] {
                
                var stationCollection = [Station]()
                
                for station in stations {
                    if let stationId = station["id"] as? String {
                        
                        if let lastUpdated = station["timestamp"] as? String, let latitude = station["latitude"] as? Double,
                            let longitude = station["longitude"] as? Double, let name = station["name"] as? String {
                            
                            // These are failable, so keep them out of conditional binding
                            let bikes = station["free_bikes"] as? Int ?? 0
                            let slots = station["empty_slots"] as? Int ?? 0
                            
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
                                
                                let location = CLLocation(latitude: latitude, longitude: longitude)
                                let station = Station(id: stationId, name: name, bikes: bikes, spaces: slots, location: location, lastUpdated: lastUpdated, sellsTickets: sellsTickets)
                                
                                // Add to stations collection
                                stationCollection.append(station)
                            }
                        }
                    }
                }
                
                success(stationCollection)
            } else {
                failure(nil)
            }

        }, andFailure: { error in })
    }
}

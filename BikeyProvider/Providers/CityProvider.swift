//
//  CityProvider.swift
//  BikeyGo
//
//  Created by Pete Smith on 31/05/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import CoreLocation

public struct CityProvider {
    
    /**
     Get all available cities
     
     - parameter success: Success closure
     - parameter failure: Failure closure
     */
    public static func nearestCity(location: CLLocation, successClosure: (nearestCity: City?)->(), failureClosure: ()->()) {
        
        let url = Constants.API.baseURL + Constants.API.networks
        
        APIClient.get(url){(success, object) in
            if success {
                
                // Success, parse the city data
                if let json = object, networks = json["networks"] as? [[String : AnyObject]] {
                    
                    var cities = [City]()
                    
                    // Parse each city dictionary
                    for cityDict in networks {
                        if let name = cityDict["name"] as? String, href = cityDict["href"] as? String, locationDict = cityDict["location"] as? [String:AnyObject], latitude = locationDict["latitude"] as? Double, longitude = locationDict["longitude"] as? Double {
                            let location = CLLocation(latitude: latitude, longitude: longitude)
                            let bikeCity = City(name: name, href: href, location: location)
                            cities.append(bikeCity)
                        }
                    }
                    
                    // Now calculate the nearest city based on user's location
                    let nearestCityAndDistance = cities.map({ ($0, distanceBetweenLocations(location, locationB: $0.location)) }).minElement(){
                        $0.1 < $1.1
                    }

                    // Call our success closuse with with the nearest city if we have it or nil
                    if let city = nearestCityAndDistance?.0 {
                        successClosure(nearestCity: city)
                    } else {
                        successClosure(nearestCity: nil)
                    }
                    
                }
            } else {
                failureClosure()
            }
        }
    }
    
    /**
     Calculate the distance between two locations
     
     - parameter locationA: From
     - parameter locationB: To
     
     - returns: Distance between locations
     */
    private static func distanceBetweenLocations(locationA: CLLocation, locationB: CLLocation) -> CLLocationDistance {
        return locationA.distanceFromLocation(locationB)
    }
}


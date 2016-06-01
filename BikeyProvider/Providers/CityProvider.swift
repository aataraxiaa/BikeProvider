//
//  CityProvider.swift
//  BikeyGo
//
//  Created by Pete Smith on 31/05/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import CoreLocation

public struct BikeCityProvider {
    
    /**
     Get all available cities
     
     - parameter success: Success closure
     - parameter failure: Failure closure
     */
    public static func findNearestCity(location: CLLocation, success: (nearestCity: City?)->(), failure: ()->()) {
        
        APIClient.get { (success, object) in
            if success {
                
                // Success, parse the city data
                if let json = object, network = json["networks"] as? [[String: AnyObject]] {
                    
                    var cities = [City]()
                    
                    // Parse each city dictionary
                    for cityDict in network {
                        if let href = cityDict["href"] as? String, locationDict = cityDict["location"] as? [String:AnyObject], latitude = locationDict["latitude"] as? Double, longitude = locationDict["longitude"] as? Double {
                            let location = CLLocation(latitude: latitude, longitude: longitude)
                            let bikeCity = City(href: href, location: location)
                            cities.append(bikeCity)
                        }
                    }
                    
                    // Now calculate the nearest city based on user's location
                    var nearestCity = cities.map({ return ($0, distanceBetweenLocations(location, location: $0.location))}).reduce(cities.first){$0.1 < $1.1 ? $0 : $1}
                    
                }
            } else {
                failure()
            }
        }
    }
    
    private static func distanceBetweenLocations(center: CLLocation, location: CLLocation) -> CLLocationDistance {
        return center.distanceFromLocation(location)
    }
}


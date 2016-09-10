//
//  CityProvider.swift
//  BikeyGo
//
//  Created by Pete Smith on 31/05/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import CoreLocation

/**
 
 ### CityProvider
 
 Provides methods for fetching the nearest bike station cities, 
 based on the parameters passed (e.g Current locaion)
 
*/
public struct CityProvider {
    
    /**
     Get all available cities
     
     - parameter location:      The location used to calculate the nearest cities
     - parameter success:       Success closure
     - parameter failure:       Failure closure
     */
    public static func city(near location: CLLocation, onSuccess success: @escaping (_ nearestCity: City)->(), onFailure failure: @escaping ()->()) {
        
        let successClosure = { (cities: [City]) in
            // Now calculate the nearest city based on user's location
            let nearestCityAndDistance = cities.map({ ($0, distance(from: location, to: $0.location)) }).min() {
                $0.1 < $1.1
            }
            
            // Call our success closuse with with the nearest city if we have it or nil
            if let city = nearestCityAndDistance?.0 {
                success(city)
            } else {
                failure()
            }
        }
        
        CityProvider.allCities(onSuccess: successClosure, onFailure: failure)
    }
    
    /**
     Get the nearest cities, bound by limit, based on the location passed
     
     - parameter location:       The location used to calculate the nearest cities
     - parameter limit:          The number of nearest cities to fetching
     - parameter successClosure: Success closure
     - parameter failureClosure: Failure closure
     */
    public static func cities(near location: CLLocation, limit: Int, onSuccess success: @escaping (_ cities: [City])->(), onFailure failure: @escaping ()->()) {
        
        let successClosure = { (cities: [City]) in
            // Now calculate the nearest city based on user's location
            let nearestCities = cities.map({ ($0, distance(from: location, to: $0.location)) }).sorted(by: { $0.1 < $1.1 }).map() { return $0.0 }
            
            // Return early with all sorted cities if the number of cities we want (our limit) is greater than the total number of cities
            guard limit < nearestCities.count else {
                success(nearestCities)
                return
            }
            
            let limitedCities = nearestCities[0..<limit]
            success(Array(limitedCities))
        }
        
        CityProvider.allCities(onSuccess: successClosure, onFailure: failure)
    }
    
    /**
     Get the nearest cities, bound by limit, based on the location passed, 
     and within a certain radius
     
     - parameter location:       The location used to calculate the nearest cities
     - parameter radius:         The radius in metres
     - parameter limit:          The number of nearest cities to fetching
     - parameter successClosure: Success closure
     - parameter failureClosure: Failure closure
     */
    public static func cities(near location: CLLocation, within radius: Double, limit: Int, onSuccess success: @escaping (_ cities: [City])->(), onFailure failure: @escaping ()->()) {
        
        let successClosure = { (cities: [City]) in
            // Now calculate cities within the radius parameter
            let citiesAndDistances = cities.map({ ($0, distance(from: location, to: $0.location)) })
            
            let citiesWithinRadius = citiesAndDistances.filter( { $0.1 < radius } ).map() { return $0.0 }
            
            // Call our success closure
            if citiesWithinRadius.count > 0 {
                
                guard limit < citiesWithinRadius.count else {
                    success(citiesWithinRadius)
                    return
                }
                
                let limitedCities = citiesWithinRadius[0..<limit]
                success(Array(limitedCities))
                
            } else if let nearestCityAndDistance = citiesAndDistances.min( by: { $0.1 < $1.1 } ) {
                success([nearestCityAndDistance.0])
            } else {
                failure()
            }
        }
        
        CityProvider.allCities(onSuccess: successClosure, onFailure: failure)
    }
    
    /**
     Get all available bike station cities
     
     - parameter successClosure: Success closure
     - parameter failureClosure: Failure closure
     */
    public static func allCities(onSuccess success: @escaping (([City]) -> Void), onFailure failure: @escaping () -> Void) {
        let url = Constants.API.baseURL + Constants.API.networks
        
        APIClient.get(from: url){ (successFul, object) in
            if successFul {
                
                // Success, parse the city data
                if let json = object, let networks = json["networks"] as? [[String : AnyObject]] {
                    
                    let cities = CityProvider.parseCities(fromJson: networks)
                    
                    if cities.count > 0 {
                        success(cities)
                    } else {
                        failure()
                    }
                }
            } else {
                failure()
            }
        }
    }
    
    /**
     Calculate the distance between two locations
     
     - parameter locationA: From
     - parameter locationB: To
     
     - returns: Distance between locations
     */
    private static func distance(from locationA: CLLocation, to locationB: CLLocation) -> CLLocationDistance {
        return locationA.distance(from: locationB)
    }
    
    private static func parseCities(fromJson json: [[String:AnyObject]]) -> [City] {
        var cities = [City]()
        
        // Parse each city dictionary
        for cityDict in json {
            if let url = cityDict["href"] as? String, let locationDict = cityDict["location"] as? [String:AnyObject], let cityName = locationDict["city"] as? String, let latitude = locationDict["latitude"] as? Double, let longitude = locationDict["longitude"] as? Double {
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let bikeCity = City(name: cityName, url: url, location: location)
                cities.append(bikeCity)
            }
        }
        
        return cities
    }
}


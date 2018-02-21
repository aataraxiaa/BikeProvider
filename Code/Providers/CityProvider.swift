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
    @discardableResult public static func city(near location: CLLocation,
                            onSuccess success: @escaping (_ nearestCity: City)->(),
                            onFailure failure: @escaping (_ error: Error)->()) -> URLSessionDataTask? {
        
        let successClosure = { (cityList: CityList) in
            // Now calculate the nearest city based on user's location
            let nearestCityAndDistance = cityList.cities.map({ ($0, distance(from: location, to: $0.location.coordinates)) }).min() {
                $0.1 < $1.1
            }
            
            // Call our success closuse with with the nearest city if we have it or nil
            if let city = nearestCityAndDistance?.0 {
                success(city)
            } else {
                failure(CityError.noCityNearLocation)
            }
        }
        
        return CityProvider.allCities(onSuccess: successClosure, onFailure: failure)
    }
    
    /**
     Get the nearest cities, bound by limit, based on the location passed
     
     - parameter location:       The location used to calculate the nearest cities
     - parameter limit:          The number of nearest cities to fetching
     - parameter successClosure: Success closure
     - parameter failureClosure: Failure closure
     */
    @discardableResult public static func cities(near location: CLLocation, limit: Int,
                                                 onSuccess success: @escaping (_ cities: CityList)->(),
                                                 onFailure failure: @escaping (_ error: Error)->()) -> URLSessionDataTask? {
        
        let successClosure = { (cityList: CityList) in
            // Now calculate the nearest city based on user's location
            let nearestCities = cityList.cities.map({ ($0, distance(from: location, to: $0.location.coordinates)) }).sorted(by: { $0.1 < $1.1 }).map() { return $0.0 }
            
            // Return early with all sorted cities if the number of cities we want (our limit) is greater than the total number of cities
            guard limit < nearestCities.count else {
                let nearestCityList = CityList(cities: nearestCities)
                success(nearestCityList)
                return
            }
            
            let limitedCities = nearestCities[0..<limit]
            let limitedCityList = CityList(cities: Array(limitedCities))
            success(limitedCityList)
        }
        
        return CityProvider.allCities(onSuccess: successClosure, onFailure: failure)
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
    @discardableResult public static func cities(near location: CLLocation,
                                                 within radius: Double, limit: Int,
                                                 onSuccess success: @escaping (_ cities: CityList)->(),
                                                 onFailure failure: @escaping (_ error: Error)->()) -> URLSessionDataTask? {
        
        let successClosure = { (cityList: CityList) in
            // Now calculate cities within the radius parameter
            let citiesAndDistances = cityList.cities.map({ ($0, distance(from: location, to: $0.location.coordinates)) })
            
            let citiesWithinRadius = citiesAndDistances.filter( { $0.1 < radius } ).map() { return $0.0 }
            fo
            // Call our success closure
            if citiesWithinRadius.count > 0 {
                
                guard limit < citiesWithinRadius.count else {
                    let radiusCityList = CityList(cities: citiesWithinRadius)
                    success(radiusCityList)
                    return
                }
                
                let limitedCities = citiesWithinRadius[0..<limit]
                let limitedCityList = CityList(cities: Array(limitedCities))
                success(limitedCityList)
                
            } else if let nearestCityAndDistance = citiesAndDistances.min( by: { $0.1 < $1.1 } ) {
                let nearestCityList = CityList(cities: [nearestCityAndDistance.0])
                success(nearestCityList)
            } else {
                failure(CityError.noCityNearLocation)
            }
        }
        
        return CityProvider.allCities(onSuccess: successClosure, onFailure: failure)
    }
    
    /**
     Get all available bike station cities
     
     - parameter successClosure: Success closure
     - parameter failureClosure: Failure closure
     */
    @discardableResult public static func allCities(onSuccess success: @escaping ((CityList) -> Void),
                                                    onFailure failure: @escaping (_ error: Error) -> Void) -> URLSessionDataTask? {
        let url = Constants.API.baseURL + Constants.API.networks
        
        return APIClient.get(from: url, withSuccess: { data in
            
            let decoder = JSONDecoder()
            if let cityList = try? decoder.decode(CityList.self, from: data), cityList.cities.count > 0 {
                success(cityList)
            } else {
                failure(CityError.noCitiesRetrieved)
            }
            
        }, andFailure: { error in
            failure(error)
        })
    }
    
    /**
     Calculate the distance between two locations
     
     - parameter locationA: From
     - parameter locationB: To
     
     - returns: Distance between locations
     */
    fileprivate static func distance(from locationA: CLLocation, to locationB: CLLocation) -> CLLocationDistance {
        return locationA.distance(from: locationB)
    }
}


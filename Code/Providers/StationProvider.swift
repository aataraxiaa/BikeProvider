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
    @discardableResult static public func stations(fromCityURL url: String,
                                                   withCompletion completion: @escaping (Result<[Station]>) -> Void) -> URLSessionDataTask? {
        
        let url = Constants.API.baseURL+url+Constants.API.requestOptions
        
        return APIClient.get(from: url, withCompletion: { (result: Result<Data>) in
            
            switch result {
            case .success(let data):
                
                let decoder = JSONDecoder()
                let stationList = try? decoder.decode(StationList.self, from: data)
                
                if let stations = stationList?.network.stations, stations.count > 0 {
                    completion(.success(stations))
                }
                
            case .failure(_):
                
                completion(.failure(StationError.noStationsRetrieved))
            }
        })
    }
    
    
    /// Gets all bike stations for each city specified in the cities parameter
    ///
    /// - Parameters:
    ///   - cities: Cities to fetch bike stations for
    ///   - success: Success closure
    ///   - failure: Failure closure
    static public func stations(forCityList cityList: CityList,
                                withCompletion completion: @escaping (Result<[Station]>) -> Void) {
        
        /*
         Group our requests so that we can asynchronously
         call success/failure when all requests are finished
         */
        
        let dispatchGroup = DispatchGroup()
        var allStations = [Station]()
        var requestError: Error?
        
        cityList.cities.forEach {
            
            // Enter dispatch group
            dispatchGroup.enter()
            
            // Start request
            StationProvider.stations(fromCityURL: $0.href, withCompletion: { result in
                
                switch result {
                case .success(let stations):
                    
                    // Add stations
                    allStations.append(contentsOf: stations)
                    
                    // Leave group
                    dispatchGroup.leave()
                    
                case .failure(let error):
                    
                    // Note error
                    requestError = error
                    
                    // Leave group
                    dispatchGroup.leave()
                }
            })
            
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            
            // Execute the success or failure closure
            switch (requestError, allStations.count > 0) {
                
            case (let error?, false):
                completion(.failure(error))
                
            case (_, true):
                completion(.success(allStations))
                
            default:
                break
            }
            
        }
    }
}

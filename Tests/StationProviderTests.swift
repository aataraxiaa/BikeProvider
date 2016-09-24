//
//  Created by Pete Smith
//  http://www.petethedeveloper.com
//
//
//  License
//  Copyright © 2016-present Pete Smith
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import XCTest
import CoreLocation
@testable import SPBBikeProvider

class StationProviderTests: XCTestCase {
    
    let dublin = CLLocation(latitude: 53.3498, longitude: -6.2603)
    let marseille = CLLocation(latitude: 43.296482, longitude: 5.36978)
    let darmstadt = CLLocation(latitude: 49.8707135, longitude: 8.6527299)
    let hoboken = CLLocation(latitude: 40.747780, longitude: -74.032774)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetStations() {
        
        // Create an expectation object.
        let stationsRetrieved = expectation(description: "Stations retrieved")
        
        CityProvider.city(near: dublin, onSuccess: { nearestCity in
            
            StationProvider.stations(fromCityURL: nearestCity.url, onSuccess: { stations in
                XCTAssert(stations.count > 0)
                
                stationsRetrieved.fulfill()
                
                }, onFailure: {
                    XCTFail("Could not retrieve stations")
            })
            
            }, onFailure: {
            XCTFail("Could not locate nearest city")
        })
        
        waitForExpectations(timeout: 10, handler: { error in })

    }
    
    // TEMP DISABLED
//    func testGetStationsAllCities() {
//        
//        var cities = [City]()
//        
//        // Get a list of all our cities
//        let citiesRetrieved = self.expectationWithDescription("Cities retrieved")
//        
//        CityProvider.allCities({ retrievedCities in
//            cities = retrievedCities
//            citiesRetrieved.fulfill()
//        }) {
//            XCTFail("Could not get cities")
//        }
//        
//        waitForExpectationsWithTimeout(10, handler: { error in })
//        
//        // For each city, get the stations
//        for city in cities {
//            
//            // Create an expectation object.
//            let stationsRetrieved = expectationWithDescription("Stations retrieved")
//            
//            StationProvider.getStations(city.href, success: { stations in
//                XCTAssert(stations.count > 0)
//                
//                stationsRetrieved.fulfill()
//                
//                }, failure: {
//                    XCTFail("Could not retrieve stations for \(city.name) at endpoint \(city.href)")
//            })
//            
//            waitForExpectationsWithTimeout(10, handler: { error in })
//        }
//    }
}

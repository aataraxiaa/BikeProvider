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
@testable import BikeProvider

struct CityProviderTestsConstants {
    static let dublinBikeName = "Dublin"
}

class CityProviderTests: XCTestCase {
    
    let dublinLocation = CLLocation(latitude: 53.3498, longitude: -6.2603)
    let newYorkWestLocation = CLLocation(latitude: 40.746172, longitude: -73.992681)
    
    let radius: Double = 20000

    func testCityNear() {
        
        // Create an expectation object.
        let cityRetrievedExpectation = expectation(description: "Nearest city retrieved")
        
        CityProvider.city(near: dublinLocation, onSuccess: { nearestCity in
            XCTAssert(nearestCity.location.name == CityProviderTestsConstants.dublinBikeName)
            
            cityRetrievedExpectation.fulfill()
            }, onFailure: { _ in
            XCTFail("Could not locate nearest city")
        })
        
        waitForExpectations(timeout: 5, handler: { error in
            
        })
    }
    
    func testCitiesNear() {
        
        // Create expectation
        let nearestTwoCitiesExpectation = expectation(description: "Cities within radius retrieved")
        
        CityProvider.cities(near: newYorkWestLocation, limit: 2, onSuccess: { cityList in
            XCTAssert(cityList.cities.count == 2)
            
            nearestTwoCitiesExpectation.fulfill()
            
            }, onFailure: { _ in
                XCTFail("Could not locate cities within radius")
        })
        
        waitForExpectations(timeout: 5, handler: { error in
            
        })
        
    }
    
    func testCitiesNearWithRadius() {
        
        // Create expectation
        let citiesWithinRadiusExpectation = expectation(description: "Cities within radius retrieved")
        
        CityProvider.cities(near: newYorkWestLocation, within: radius, limit: 2, onSuccess: { cityList in
            XCTAssert(cityList.cities.count == 2)
            
            citiesWithinRadiusExpectation.fulfill()
            
            }, onFailure: { _ in
            XCTFail("Could not locate cities within radius")
        })
        
        waitForExpectations(timeout: 5, handler: { error in
            
        })
    }
    
    func testCityLimitedToOneNearWithRadius() {
        
        // Create expectation
        let citiesWithinRadiusExpectation = expectation(description: "Cities within radius retrieved")
        
        CityProvider.cities(near: newYorkWestLocation, within: radius, limit: 1, onSuccess: { cityList in
            
            XCTAssert(cityList.cities.count == 1)
            
            citiesWithinRadiusExpectation.fulfill()
            
        }, onFailure: { _ in
            XCTFail("Could not locate cities within radius")
        })
        
        waitForExpectations(timeout: 5, handler: { error in
            
        })
    }
    
    func testAllCities() {
        
        // Create expectation
        let allCitiesExpectation = expectation(description: "All cities retrieved")
        
        CityProvider.allCities(onSuccess: { cityList in
            
            XCTAssert(!cityList.cities.isEmpty)
            
            allCitiesExpectation.fulfill()
            
        }) { _ in
            XCTFail("Failed to fetch all cities")
        }
        
        waitForExpectations(timeout: 5, handler: { _ in })
    }
}

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

struct CityProviderTestsConstants {
    static let dublinBikeName = "Dublin"
}

class CityProviderTests: XCTestCase {
    
    let dublinLocation = CLLocation(latitude: 53.3498, longitude: -6.2603)
    let newYorkWestLocation = CLLocation(latitude: 40.746172, longitude: -73.992681)
    
    let radius: Double = 20000

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testNearestCity() {
        
        // Create an expectation object.
        let cityRetrievedExpectation = expectation(description: "Nearest city retrieved")
        
        CityProvider.city(near: dublinLocation, onSuccess: { nearestCity in
            XCTAssert(nearestCity.name == CityProviderTestsConstants.dublinBikeName)
            
            cityRetrievedExpectation.fulfill()
            }, onFailure: {
            XCTFail("Could not locate nearest city")
        })
        
        waitForExpectations(timeout: 5, handler: { error in
            
        })
    }
    
    func testNearestTwoCities() {
        
        // Create expectation
        let nearestTwoCitiesExpectation = expectation(description: "Cities within radius retrieved")
        
        CityProvider.cities(near: newYorkWestLocation, limit: 2, onSuccess: { cities in
            XCTAssert(cities.count == 2)
            
            nearestTwoCitiesExpectation.fulfill()
            
            }, onFailure: {
                XCTFail("Could not locate cities within radius")
        })
        
        waitForExpectations(timeout: 5, handler: { error in
            
        })
        
    }
    
    func testCitiesWithinRadius() {
        
        // Create expectation
        let citiesWithinRadiusExpectation = expectation(description: "Cities within radius retrieved")
        
        CityProvider.cities(near: newYorkWestLocation, within: radius, limit: 2, onSuccess: { cities in
            XCTAssert(cities.count == 2)
            
            citiesWithinRadiusExpectation.fulfill()
            
            }, onFailure: {
            XCTFail("Could not locate cities within radius")
        })
        
        waitForExpectations(timeout: 5, handler: { error in
            
        })

    }
}

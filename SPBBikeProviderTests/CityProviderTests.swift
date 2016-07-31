//
//  CityProviderTests.swift
//  BikeyProvider
//
//  Created by Pete Smith on 01/06/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import XCTest
import CoreLocation

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
        let cityRetrievedExpectation = expectationWithDescription("Nearest city retrieved")
        
        CityProvider.nearestCity(dublinLocation, successClosure: { nearestCity in
            XCTAssert(nearestCity.name == CityProviderTestsConstants.dublinBikeName)
            
            cityRetrievedExpectation.fulfill()
        }, failureClosure: {
            XCTFail("Could not locate nearest city")
        })
        
        waitForExpectationsWithTimeout(5, handler: { error in
            
        })
    }
    
    func testNearestTwoCities() {
        
        // Create expectation
        let nearestTwoCitiesExpectation = expectationWithDescription("Cities within radius retrieved")
        
        CityProvider.nearestCities(2, location: newYorkWestLocation, successClosure: { cities in
            XCTAssert(cities.count == 2)
            
            nearestTwoCitiesExpectation.fulfill()
            
            }, failureClosure: {
                XCTFail("Could not locate cities within radius")
        })
        
        waitForExpectationsWithTimeout(5, handler: { error in
            
        })
        
    }
    
    func testCitiesWithinRadius() {
        
        // Create expectation
        let citiesWithinRadiusExpectation = expectationWithDescription("Cities within radius retrieved")
        
        CityProvider.cities(within: radius, limit: 2, location: newYorkWestLocation, successClosure: { cities in
            XCTAssert(cities.count == 2)
            
            citiesWithinRadiusExpectation.fulfill()
            
        }, failureClosure: {
            XCTFail("Could not locate cities within radius")
        })
        
        waitForExpectationsWithTimeout(5, handler: { error in
            
        })

    }
}

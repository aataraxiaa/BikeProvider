//
//  StationProviderTests.swift
//  BikeyProvider
//
//  Created by Peter Smith on 03/06/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//
import XCTest
import CoreLocation
@testable import BikeyProvider

class StationProviderTests: XCTestCase {
    
    let dublinLocation = CLLocation(latitude: 53.3498, longitude: 6.2603)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetStations() {
        
        // Create an expectation object.
        let stationsRetrieved = expectationWithDescription("Stations retrieved")
        
        CityProvider.nearestCity(dublinLocation, successClosure: { nearestCity in
            
            if let city = nearestCity {
                StationProvider.getStations(city.href, success: { stations in
                    XCTAssert(stations?.count > 0)
                    
                    stationsRetrieved.fulfill()
                    
                }, failure: {
                    XCTFail("Could not retrieve stations")
                })
            } else {
                XCTFail("Could not locate nearest city")
            }
            
        }, failureClosure: {
            XCTFail("Could not locate nearest city")
        })
        
        waitForExpectationsWithTimeout(10, handler: { error in })

    }
}

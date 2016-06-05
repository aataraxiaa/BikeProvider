//
//  CityProviderTests.swift
//  BikeyProvider
//
//  Created by Pete Smith on 01/06/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import XCTest
import CoreLocation
@testable import BikeyProvider

struct CityProviderTestsConstants {
    static let dublinBikeName = "dublinbikes"
}

class CityProviderTests: XCTestCase {
    
    let dublinLocation = CLLocation(latitude: 53.3498, longitude: -6.2603)

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
            XCTAssert(nearestCity != nil && nearestCity?.name == CityProviderTestsConstants.dublinBikeName)
            
            cityRetrievedExpectation.fulfill()
        }, failureClosure: {
            XCTFail("Could not locate nearest city")
        })
        
        waitForExpectationsWithTimeout(10, handler: { error in
            
        })
    }
}

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

class CityProviderTests: XCTestCase {
    
    let dublinLocation = CLLocation(latitude: 53.3498, longitude: 6.2603)

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAsynchronousNearestCity() {
        
        // Create an expectation object.
        // This test only has one, but it's possible to wait on multiple expectations.
        let cityRetrievedExpectation = expectationWithDescription("Nearest City Retrieved")
        
        CityProvider.nearestCity(dublinLocation, successClosure: { nearestCity in
            //XCTAssert(nearestCity != nil)
            print(nearestCity)
            
            cityRetrievedExpectation.fulfill()
        }, failureClosure: {})
        
        waitForExpectationsWithTimeout(10, handler: { error in
            
        })
    }

}

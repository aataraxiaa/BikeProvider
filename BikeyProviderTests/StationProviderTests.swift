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
        let stationsRetrieved = expectationWithDescription("Stations retrieved")
        
        CityProvider.nearestCity(dublin, successClosure: { nearestCity in
            
                StationProvider.getStations(nearestCity.href, success: { stations in
                    XCTAssert(stations.count > 0)
                    
                    for station in stations {
                        print(station.name)
                    }
                    
                    stationsRetrieved.fulfill()
                    
                }, failure: {
                    XCTFail("Could not retrieve stations")
                })
            
        }, failureClosure: {
            XCTFail("Could not locate nearest city")
        })
        
        waitForExpectationsWithTimeout(10, handler: { error in })

    }
    
    func testGetStationsAllCities() {
        
        var cities = [City]()
        
        // Get a list of all our cities
        let citiesRetrieved = self.expectationWithDescription("Cities retrieved")
        
        CityProvider.allCities({ retrievedCities in
            cities = retrievedCities
            citiesRetrieved.fulfill()
        }) {
            XCTFail("Could not get cities")
        }
        
        waitForExpectationsWithTimeout(10, handler: { error in })
        
        // For each city, get the stations
        for city in cities {
            
            // Create an expectation object.
            let stationsRetrieved = expectationWithDescription("Stations retrieved")
            
            StationProvider.getStations(city.href, success: { stations in
                XCTAssert(stations.count > 0)
                
                stationsRetrieved.fulfill()
                
                }, failure: {
                    XCTFail("Could not retrieve stations")
            })
            
            waitForExpectationsWithTimeout(10, handler: { error in })
        }
    }
    
    func testFormatStationNamesDelimiterOne() {
        
        // Create array of names to format
        let names = Array(count: 100, repeatedValue: "12345 - suffix")
        
        for name in names {
            XCTAssert(StationProvider.stationDisplayName(name) == "suffix")
        }
    }
    
    func testFormatStationNamesDelimiterTwo() {
        
        // Create array of names to format
        let names = Array(count: 100, repeatedValue: "54321-suffix")
        
        for name in names {
            XCTAssert(StationProvider.stationDisplayName(name) == "suffix")
        }
    }
    
    func testFormatStationNamesDelimiterThree() {
        
        // Create array of names to format
        let names = Array(count: 100, repeatedValue: "12345 : suffix")
        
        for name in names {
            XCTAssert(StationProvider.stationDisplayName(name) == "suffix")
        }
    }
}

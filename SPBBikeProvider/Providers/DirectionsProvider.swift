//
//  DirectionsProvider.swift
//  BikeyProvider
//
//  Created by Pete Smith on 05/06/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import MapKit

/**
 ### DirectionsProvider
 
 Performs direction requests using MapKit directions
 */
public struct DirectionsProvider {
    
    // Keep track of the active direction request so we can cancel if needed
    private static var activeDirectionsRequest: MKDirections?
    
    /**
     Retrieve directions between two locations
     
     - parameter start:   Start location
     - parameter end:     End location
     - parameter success: Success closure which takes a route
     - parameter failure: Failure closure
     */
    public static func directions(from start: CLLocation, to end: CLLocation, success: ((_ route: MKRoute) -> Void), failure: (() -> Void)) {
        
        // Cancel any pending directions requests
        activeDirectionsRequest?.cancel()
        
        // Construct our required MKMapItems
        
        let sourcePlaceMark = MKPlacemark(coordinate: start.coordinate, addressDictionary:nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationPlacemark: MKPlacemark = MKPlacemark(coordinate: end.coordinate, addressDictionary:nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let req = MKDirectionsRequest()
        req.source = sourceMapItem
        req.destination = destinationMapItem
        req.transportType = MKDirectionsTransportType.walking
        activeDirectionsRequest = MKDirections(request:req)
        
        // Perform the directions request
        activeDirectionsRequest?.calculate { response, error in
            if response == nil && error != nil {
                print("Directions error: \(error)")
                
                // TODO: HANDLE FAILURE FOR ALL CASES
                failure()
                return
            }
            
            if let route = response?.routes[0] {
                success(route)
            }
        }
    }
    
    /**
     Cancel any current direction request
     */
    public static func cancelCurrentRequest() {
        activeDirectionsRequest?.cancel()
    }
}

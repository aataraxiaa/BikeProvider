//
//  DirectionsProvider.swift
//  BikeyProvider
//
//  Created by Pete Smith on 05/06/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import MapKit

/**
 *  Handles direction requests using MapKit directions
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
    public static func getDirections(start: CLLocation, end: CLLocation, success: ((route: MKRoute) -> Void), failure: (() -> Void)) {
        
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
        req.transportType = MKDirectionsTransportType.Walking
        activeDirectionsRequest = MKDirections(request:req)
        
        // Perform the directions request
        activeDirectionsRequest?.calculateDirectionsWithCompletionHandler ({
            (response: MKDirectionsResponse?, error: NSError?) -> Void in
            
            if response == nil && error != nil {
                print("Directions error: \(error)")
                
                // TODO: HANDLE FAILURE FOR ALL CASES
                failure()
                return
            }
            
            if let route = response?.routes[0] {
                success(route: route)
            }
        })
        
    }
    
    public static func cancelCurrentRequest() {
        activeDirectionsRequest?.cancel()
    }
}

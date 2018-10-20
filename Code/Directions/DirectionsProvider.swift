//
//  Created by Pete Smith
//  http://www.petethedeveloper.com
//
//
//  License
//  Copyright © 2016-present Pete Smith
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import MapKit

/**
 ### DirectionsProvider
 
 Performs direction requests using MapKit directions
 */
public struct DirectionsProvider {
    
    // Keep track of the active direction request so we can cancel if needed
    fileprivate static var activeDirectionsRequest: MKDirections?
    
    /**
     Retrieve directions between two locations
     
     - parameter start:   Start location
     - parameter end:     End location
     - parameter success: Success closure which takes a route
     - parameter failure: Failure closure
     */
    public static func directions(from start: CLLocation, to end: CLLocation, success: @escaping ((_ route: MKRoute) -> Void), failure: @escaping (() -> Void)) {
        
        // Cancel any pending directions requests
        activeDirectionsRequest?.cancel()
        
        // Construct our required MKMapItems
        
        let sourcePlaceMark = MKPlacemark(coordinate: start.coordinate, addressDictionary:nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationPlacemark: MKPlacemark = MKPlacemark(coordinate: end.coordinate, addressDictionary:nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let req = MKDirections.Request()
        req.source = sourceMapItem
        req.destination = destinationMapItem
        req.transportType = MKDirectionsTransportType.walking
        activeDirectionsRequest = MKDirections(request:req)
        
        // Perform the directions request asynchronously on a global 'utility' queue
        DispatchQueue.global(qos: .utility).async {
            
            self.activeDirectionsRequest?.calculate { response, error in
                
                if response == nil && error != nil {
                    
                    // TODO: HANDLE FAILURE FOR ALL CASES
                    failure()
                    return
                }
                
                if let route = response?.routes[0] {
                    success(route)
                }
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

//
//  PSBLocationManager.swift
//  Bikey
//
//  Created by Peter Smith on 22/09/2015.
//  Copyright © 2015 PeteSmith. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

private struct LocationManagerConstants {
    static let REQACC: CLLocationAccuracy = 70
}

public protocol LocationManagerDelegate {
    func locationSuccessfullyRetrieved(currentLocation: CLLocation)
    func locationAccessedDenied()
}

final public class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // Singleton
    public static let sharedInstance = LocationManager()
    
    public var delegate: LocationManagerDelegate?
    
    // Location properties
    private var locman = CLLocationManager()
    private var startTime: NSDate!
    private var trying = false
    
    // Heading
    private var updatingHeading = false
    
    // Directions
    // Keep track of the active direction request so we can cancel if needed
    private var activeDirectionsRequest: MKDirections?
    
    private override init() {
        // Location Manager
        super.init()
        locman.delegate = self
        locman.desiredAccuracy = kCLLocationAccuracyBest
        locman.activityType = .Fitness
        locman.pausesLocationUpdatesAutomatically = true
    }
    
    // MARK: - CLLocationManager Delegate
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        stopTrying()
        stopTryingHeading()

        delegate?.locationAccessedDenied()
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last
        let acc = loc!.horizontalAccuracy
        
        if acc < 0 || acc > LocationManagerConstants.REQACC {
            return // wait for the next one
        }
        
        // Location retrieved!!
        delegate?.locationSuccessfullyRetrieved(loc!)
    }
    
    // MARK: Location helper methods
    
    private func determineStatus() -> Bool {
        let ok = CLLocationManager.locationServicesEnabled()
        
        if !ok {
            return true // ! this is so that we try to use it anyway...
            // system will put up a dialog suggesting the user turn on Location Services
        }
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            return true
        case .NotDetermined:
            locman.requestAlwaysAuthorization()
            return true
        case .Restricted:
            delegate?.locationAccessedDenied()
            return false
        case .Denied:
            delegate?.locationAccessedDenied()
            return false
        }
    }
    
    public func getCurrentLocation() {
        if !determineStatus() {
            delegate?.locationAccessedDenied()
            return
        }
        
        if trying {
            return
        }
        
        trying = true
        startTime = nil
        locman.startUpdatingLocation()
    }
    
    public func stopTrying () {
        locman.stopUpdatingLocation()
        startTime = nil
        trying = false
    }
    
    public func getCurrentHeading() {
        if !CLLocationManager.headingAvailable() {
            return
        }
        
        if updatingHeading {
            return
        }

        self.locman.headingFilter = 5
        self.locman.headingOrientation = .Portrait
        updatingHeading = true
        self.locman.startUpdatingHeading()
    }
    
    private func stopTryingHeading() {
        locman.stopUpdatingHeading()
        updatingHeading = false
    }
    
    // MARK: - Directions
    
    public func getDirections(startLocation: CLLocation, endLocation: CLLocation, success: ((route: MKRoute) -> Void), failure: (() -> Void)) {
        
        // Cancel any pending directions requests
        activeDirectionsRequest?.cancel()
        
        // Construct our required MKMapItems
        
        let sourcePlaceMark = MKPlacemark(coordinate: startLocation.coordinate, addressDictionary:nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationPlacemark: MKPlacemark = MKPlacemark(coordinate: endLocation.coordinate, addressDictionary:nil)
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
            
            // Save the MKRoute information for this BikeStation
            if let route = response?.routes[0] {
                success(route: route)
            }
        })

    }
    
    public func cancelCurrentDirectionsRequest() {
        activeDirectionsRequest?.cancel()
    }
}

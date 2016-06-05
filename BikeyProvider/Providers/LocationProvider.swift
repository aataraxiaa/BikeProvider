//
//  LocationProvider.swift
//  BikeyProvider
//
//  Created by Pete Smith on 05/06/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import CoreLocation

private struct LocationProviderConstants {
    static let requiredAccuracy: CLLocationAccuracy = 70
}

/**
 *  Location Provider delegate protocol
 */
public protocol LocationProviderDelegate {
    func locationRetrieved(currentLocation: CLLocation)
    func locationAccessDenied()
}

/// Singleton which provides location services via a delegate
final public class LocationProvider: NSObject, CLLocationManagerDelegate {
    
    // Singleton
    public static let sharedInstance = LocationProvider()
    
    // MARK: - Public properties
    public var delegate: LocationProviderDelegate?
    
    // MARK: - Private properties
    private var locman = CLLocationManager()
    private var startTime: NSDate!
    private var trying = false
    
    // MARK: - Initialization
    private override init() {
        super.init()
        locman.delegate = self
        locman.desiredAccuracy = kCLLocationAccuracyBest
        locman.activityType = .Fitness
        locman.pausesLocationUpdatesAutomatically = true
    }
    
    // MARK: - CLLocationManager Delegate
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        stopTrying()
        
        delegate?.locationAccessDenied()
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last
        let acc = loc!.horizontalAccuracy
        
        if acc < 0 || acc > LocationProviderConstants.requiredAccuracy {
            return // wait for the next one
        }
        
        // Location retrieved!!
        delegate?.locationRetrieved(loc!)
    }
    
    // MARK: - Public functions
    
    public func getLocation() {
        if !determineStatus() {
            delegate?.locationAccessDenied()
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

    // MARK: - Location helper functions
    
    private func determineStatus() -> Bool {
        let ok = CLLocationManager.locationServicesEnabled()
        
        if !ok {
            // System will display dialog prompting for location access
            return true
        }
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            return true
        case .NotDetermined:
            locman.requestAlwaysAuthorization()
            return true
        case .Restricted:
            delegate?.locationAccessDenied()
            return false
        case .Denied:
            delegate?.locationAccessDenied()
            return false
        }
    }
}

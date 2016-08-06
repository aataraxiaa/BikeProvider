//
//  LocationProvider.swift
//  BikeyProvider
//
//  Created by Pete Smith on 05/06/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import CoreLocation

/**
 ### LocationProviderDelegate
 
 Location Provider delegate protocol
 */
public protocol LocationProviderDelegate {
    func retrieved(location: CLLocation)
    func accessDenied()
    func retrieved(heading: CLHeading)
    func locationAccess(isGranted: Bool)
}

/**
 Empty extension to make some delegate methods optional
 */
public extension LocationProviderDelegate {
    func retrieved(heading: CLHeading) {}
    func locationAccess(isGranted: Bool){}
}

/** 
 ### LocationProvider
 
 Provides location services such as current location, currect heading
 Messages are sent to the specified delegate
*/
final public class LocationProvider: NSObject, CLLocationManagerDelegate {
    
    // Singleton
    public static let sharedInstance = LocationProvider()
    
    // MARK: - Public properties
    public var delegate: LocationProviderDelegate?
    var requiredAccuracy: CLLocationAccuracy = 70
    
    // MARK: - Private properties
    private var locman = CLLocationManager()
    private var startTime: Date!
    private var trying = false
    private var updatingHeading = false
    
    // MARK: - Initialization
    private override init() {
        super.init()
        locman.delegate = self
        locman.desiredAccuracy = kCLLocationAccuracyBest
        locman.activityType = .fitness
        locman.pausesLocationUpdatesAutomatically = true
    }
    
    // MARK: - Public Methods
    
    /**
     Request location access authorization
     */
    public func requestAlwaysAuthorization() {
        locman.requestAlwaysAuthorization()
    }
    
    /**
     Get the current location
     Location is passed back to caller using the delegate
     */
    public func getLocation() {
        if !determineStatus() {
            delegate?.accessDenied()
            return
        }
        
        if trying {
            return
        }
        
        trying = true
        startTime = nil
        locman.startUpdatingLocation()
    }
    
    /**
     Stop all location based updates (location, heading)
     */
    public func stopUpdates () {
        locman.stopUpdatingLocation()
        locman.stopUpdatingHeading()
        updatingHeading = false
        trying = false
        startTime = nil
    }
    
    /**
     Get the current heading
     */
    public func getHeading() {
        if !CLLocationManager.headingAvailable() {
            return
        }
        
        if updatingHeading {
            return
        }
        
        self.locman.headingFilter = 5
        self.locman.headingOrientation = .portrait
        updatingHeading = true
        self.locman.startUpdatingHeading()
    }
    
    // MARK: - CLLocationManager Delegate
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stopUpdates()
        
        delegate?.accessDenied()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, location.horizontalAccuracy > 0 && location.horizontalAccuracy < requiredAccuracy else { return }
        
        delegate?.retrieved(location: location)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.delegate?.retrieved(heading: newHeading)
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            delegate?.locationAccess(isGranted: true)
        default:
            delegate?.locationAccess(isGranted: false)
        }
    }

    // MARK: - Location helper methods
    
    private func determineStatus() -> Bool {
        let ok = CLLocationManager.locationServicesEnabled()
        
        if !ok {
            // System will display dialog prompting for location access
            return true
        }
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .notDetermined:
            requestAlwaysAuthorization()
            return true
        case .restricted:
            delegate?.accessDenied()
            return false
        case .denied:
            delegate?.accessDenied()
            return false
        }
    }
}

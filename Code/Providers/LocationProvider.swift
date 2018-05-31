//
//  Created by Pete Smith
//  http://www.petethedeveloper.com
//
//
//  License
//  Copyright © 2016-present Pete Smith
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import CoreLocation

/**
 ### LocationProviderDelegate
 
 Location Provider delegate protocol
 */
public protocol LocationProviderDelegate {
    func retrieved(_ location: CLLocation)
    func accessDenied()
    
    #if os(iOS)
        @available(iOS 9, *)
        func retrieved(_ heading: CLHeading)
    #endif

    func locationAccess(_ isGranted: Bool)
}

/**
 Empty extension to make some delegate methods optional
 */
public extension LocationProviderDelegate {
    #if os(iOS)
        func retrieved(_ heading: CLHeading) {}
    #endif
    func locationAccess(_ isGranted: Bool){}
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
    public var needsToRequestAccess: Bool {
        return CLLocationManager.authorizationStatus() == .notDetermined
    }
    
    // MARK: - Private properties
    fileprivate var locman = CLLocationManager()
    fileprivate var startTime: Date!
    fileprivate var trying = false
    fileprivate var updatingHeading = false
    
    // MARK: - Initialization
    fileprivate override init() {
        super.init()
        locman.delegate = self
        locman.desiredAccuracy = kCLLocationAccuracyBest
        
        #if os(iOS)
            locman.activityType = .fitness
            locman.pausesLocationUpdatesAutomatically = true
        #endif
        
    }
    
    // MARK: - Public Methods
    
    /**
     Request location access authorization
     */
    public func requestAlwaysAuthorization() {
        #if os(iOS)
            locman.requestAlwaysAuthorization()
        #endif
    }
    
    /**
     Request location access authorization
     */
    public func requestWhenInUseAuthorization() {
        #if os(iOS)
            locman.requestWhenInUseAuthorization()
        #endif
    }
    
    /**
     Get the current location
     Location is passed back to caller using the delegate
     */
    public func getLocation(withAuthScope authScope: CLAuthorizationStatus) {
        if !determineStatus(withAuthScope: authScope) {
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
        
        #if os(iOS)
            locman.stopUpdatingHeading()
        #endif
        
        updatingHeading = false
        trying = false
        startTime = nil
    }
    
    /**
     Get the current heading
     */
    @available(iOS 9, *)
    public func getHeading() {
        
        #if os(iOS)
        
            if !CLLocationManager.headingAvailable() {
                return
            }
        
            if updatingHeading {
                return
            }
        
            self.locman.headingFilter = 5
            self.locman.headingOrientation = .portrait
            self.locman.startUpdatingHeading()
        #endif
        
        updatingHeading = true
    }
    
    // MARK: - CLLocationManager Delegate
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stopUpdates()
        
        delegate?.accessDenied()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, location.horizontalAccuracy > 0 && location.horizontalAccuracy < requiredAccuracy else { return }
        
        delegate?.retrieved(location)
    }
    
    #if os(iOS)
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.delegate?.retrieved(newHeading)
    }
    #endif
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            delegate?.locationAccess(true)
        default:
            delegate?.locationAccess(false)
        }
    }

    // MARK: - Location helper methods
    
    fileprivate func determineStatus(withAuthScope authScope: CLAuthorizationStatus) -> Bool {
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
            #if os(iOS)
                if authScope == .authorizedWhenInUse {
                    requestWhenInUseAuthorization()
                } else {
                    requestAlwaysAuthorization()
                }
            #endif
            
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

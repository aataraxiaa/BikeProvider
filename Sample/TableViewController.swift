//
//  TableViewController.swift
//  SPBBikeProvider
//
//  Created by Pete Smith on 05/09/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import UIKit
import CoreLocation
import SPBBikeProvider

class TableViewController: UITableViewController {
    
    var location: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Start location updates
        LocationProvider.sharedInstance.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

typealias LocationDelegate = TableViewController
extension LocationDelegate: LocationProviderDelegate {
    
    public func accessDenied() {}
    
    func retrieved(location: CLLocation) {
        self.location = location
        // We have location, so get the nearest city
    }
}

typealias APIRequester = TableViewController
extension APIRequester {
    
    private func getNearestCity() {
        guard let location = location else { return }
        
        // Get the nearest city
        CityProvider.city(near: location, successClosure: { city in
            StationProvider.stations(in: city.href, success: {stations in
                
            }, failure: {})
        }, failureClosure: {})
    }
}

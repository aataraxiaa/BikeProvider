//
//  TableViewController.swift
//  SPBBikeProvider
//
//  Created by Pete Smith on 05/09/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import UIKit
import SPBBikeProvider

class TableViewController: UITableViewController {
    
    var location: CLLocation?

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
    
    func retrieved(location: CLLocation) {
        // We have location, so get the nearest city
    }
}

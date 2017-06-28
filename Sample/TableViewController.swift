//
//  Created by Pete Smith
//  http://www.petethedeveloper.com
//
//
//  License
//  Copyright © 2016-present Pete Smith
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit
import CoreLocation
import BikeProvider

class TableViewController: UITableViewController {
    
    // MARK: - Properties (Private)
    fileprivate var location: CLLocation!
    fileprivate var stations = [Station]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Start location updates
        LocationProvider.sharedInstance.delegate = self
        LocationProvider.sharedInstance.getLocation(withAuthScope: .authorizedWhenInUse)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let index = indexPath.row
        guard index < stations.count else { return cell }
        
        let station = stations[index]
        
        cell.textLabel?.text = station.name
        cell.detailTextLabel?.text = "Bikes: \(station.bikes)"
        
        return cell
    }
}

typealias LocationDelegate = TableViewController
extension LocationDelegate: LocationProviderDelegate {
    
    public func accessDenied() {}
    
    func retrieved(_ location: CLLocation) {
        self.location = location
        // We have location, so get the nearest city
        getStations()
    }
}

typealias APIRequester = TableViewController
extension APIRequester {
    
    fileprivate func getStations() {
        guard let location = location else { return }
        
        // Get the nearest city
        CityProvider.city(near: location, onSuccess: { city in
            StationProvider.stations(fromCityURL: city.href, onSuccess: { [weak self] stations in
                guard let strongSelf = self else { return }
                
                strongSelf.stations = stations
                strongSelf.tableView.reloadData()
                
                }, onFailure: { _ in })
            }, onFailure: { _ in })
    }
}

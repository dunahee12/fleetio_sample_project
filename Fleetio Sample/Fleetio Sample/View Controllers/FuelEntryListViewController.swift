//
//  FuelEntryListViewController.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/2/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import UIKit

class FuelEntryListViewController: UIViewController {
    
    // Public Vars
    public var fuelEntries: [FIOFuelEntry]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!

    
    // MARK: Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register tableViewCell
        tableView.register(UINib(nibName: FIOFuelEntryCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: FIOFuelEntryCell.cellIdentifier)
    }

}


// MARK: UITableView

extension FuelEntryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If fuelEntries hasn't been populated yet, let the table blank
        if fuelEntries == nil {
            return 0
        }
        
        return fuelEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get Fuel Entry
        let fuelEntry = fuelEntries[indexPath.row]
        
        // Set up cell with Fuel Entry
        let cell = tableView.dequeueReusableCell(withIdentifier: FIOFuelEntryCell.cellIdentifier, for: indexPath) as! FIOFuelEntryCell
        cell.bind(withFuelEntry: fuelEntry)
        return cell
    }
    
    
}

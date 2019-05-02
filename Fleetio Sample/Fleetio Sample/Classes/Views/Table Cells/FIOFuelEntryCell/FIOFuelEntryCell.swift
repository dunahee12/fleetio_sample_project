//
//  FIOFuelEntryCell.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/2/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import UIKit

class FIOFuelEntryCell: UITableViewCell {
    
    // Public Vars
    public static let cellIdentifier = "FIOFuelEntryCell"
    
    // IBOutlets
    @IBOutlet weak var lblVehicleName: UILabel!
    
    
    // MARK: Public Functions
    
    public func bind(withFuelEntry fuelEntry: FIOFuelEntry) {
        lblVehicleName.text = fuelEntry.vehicleName
    }
    
}

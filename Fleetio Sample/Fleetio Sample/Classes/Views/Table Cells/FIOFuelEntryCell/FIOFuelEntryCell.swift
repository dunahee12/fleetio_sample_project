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
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    
    
    // MARK: Public Functions
    
    public func bind(withFuelEntry fuelEntry: FIOFuelEntry) {
        lblVehicleName.text = fuelEntry.vehicleName
        lblDate.text = FIOGlobal.shared.dateToStringFormatter.string(from: fuelEntry.date)
        lblCost.text = String(format: "$%.02f", arguments: [fuelEntry.pricePerGallon])
    }
    
}

//
//  FuelEntryDetailViewController.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/2/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import UIKit

class FuelEntryDetailViewController: UIViewController {
    
    // Public Vars
    public var fuelEntry: FIOFuelEntry!
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    // Private Vars
    private let headerCellIdentifier = "DetailHeaderCell"
    
    
    // MARK: Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: FIOFuelDetailCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: FIOFuelDetailCell.cellIdentifier)
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = 1.0
        }
    }
    
    
    // MARK: Actions
    
    @IBAction
    func tapped(btnClose: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.alpha = 0
        }) { (complete) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}


// MARK: UITableView

extension FuelEntryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FIOFuelDetailCell.cellIdentifier, for: indexPath) as! FIOFuelDetailCell
        
        switch indexPath.row {
        case 0:
            let formattedDate = FIOGlobal.shared.dateToStringFormatter.string(from: fuelEntry.date)
            cell.bind(withTitle: "Date", value: formattedDate)
            
        case 1:
            let costString = String(format: "$%.02f", arguments: [fuelEntry.cost])
            cell.bind(withTitle: "Cost", value: costString)
            
        case 2:
            let costString = String(format: "$%.02f", arguments: [fuelEntry.costPerMile])
            cell.bind(withTitle: "Cost per mile", value: costString)
            
        case 3:
            cell.bind(withTitle: "Gallons", value: fuelEntry.gallons)
            
        case 4:
            cell.bind(withTitle: "Fuel Type", value: fuelEntry.fuelTypeName)
            
        case 5:
            let priceString = String(format: "$%.02f", arguments: [fuelEntry.pricePerGallon])
            cell.bind(withTitle: "Price per gallon", value: priceString)
            
        case 6:
            cell.bind(withTitle: "Vendor", value: fuelEntry.vendor)
            
        case 7:
            cell.bind(withTitle: "Reference Number", value: fuelEntry.referenceNumber)
            
        default: break
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = fuelEntry.vehicleName
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.contentView.backgroundColor = UIColor.fleetioGreen()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}

//
//  FuelEntryListViewController.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/2/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import UIKit

protocol FuelEntryListViewControllerDelegate: class {
    func fuelEntryListViewController(viewController: FuelEntryListViewController, didSelectFuelEntry fuelEntry: FIOFuelEntry)
    func fuelEntryListViewControllerRequestedMoreEntries(viewController: FuelEntryListViewController)
    func fuelEntryListViewControllerRequestedRefresh(viewController: FuelEntryListViewController)
}

class FuelEntryListViewController: UIViewController {
    
    // Public Vars
    public weak var delegate: FuelEntryListViewControllerDelegate?
    public var fuelEntries: [FIOFuelEntry]! {
        didSet {
            updateTable()
        }
    }
    
    public var allEntriesLoaded = false {
        didSet {
            if allEntriesLoaded && btnLoad != nil {
                btnLoad.isEnabled = !allEntriesLoaded
                btnLoad.sizeToFit()
            }
        }
    }
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEmpty: UILabel!

    // Private Vars
    var btnLoad: UIButton!
    
    
    // MARK: Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add footer to table for loading more entries
        let tableFooter = UIView()
        tableFooter.backgroundColor = .white
        tableFooter.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60)
        
        btnLoad = UIButton()
        btnLoad.setTitle("Load more entries...", for: .normal)
        btnLoad.setTitle("No more entries to load", for: .disabled)
        btnLoad.setTitleColor(UIColor.fleetioGreen(), for: .normal)
        btnLoad.setTitleColor(.lightGray, for: .disabled)
        btnLoad.addTarget(self, action: #selector(tapped(btnFooter:)), for: .touchUpInside)
        btnLoad.sizeToFit()
        btnLoad.center = tableFooter.center
        tableFooter.addSubview(btnLoad)
        tableView.tableFooterView = tableFooter
        updateTable()

        // Register tableViewCell
        tableView.register(UINib(nibName: FIOFuelEntryCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: FIOFuelEntryCell.cellIdentifier)
        
        // Added refresh control to tableView
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.fleetioGreen()
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    
    // MARK: Actions
    
    @IBAction
    func tapped(btnFooter: UIButton) {
        if !allEntriesLoaded {
            delegate?.fuelEntryListViewControllerRequestedMoreEntries(viewController: self)
        }
    }
    
    @objc
    func pulledToRefresh() {
        delegate?.fuelEntryListViewControllerRequestedRefresh(viewController: self)
    }
    
    
    // MARK: Private Functions
    
    func updateTable() {
        guard  let tableView = tableView else {
            return
        }
        
        if fuelEntries == nil || fuelEntries.isEmpty {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            tableView.reloadData()
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get Fuel Entry
        let fuelEntry = fuelEntries[indexPath.row]
        
        // Set up cell with Fuel Entry
        let cell = tableView.dequeueReusableCell(withIdentifier: FIOFuelEntryCell.cellIdentifier, for: indexPath) as! FIOFuelEntryCell
        cell.bind(withFuelEntry: fuelEntry)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Fuel Entries"
        cell.textLabel?.textColor = UIColor.fleetioGreen()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .light)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.contentView.backgroundColor = UIColor.groupTableViewBackground
        
        return cell
    }
    
    // MARK: Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let fuelEntry = fuelEntries[indexPath.row]
        delegate?.fuelEntryListViewController(viewController: self, didSelectFuelEntry: fuelEntry)
    }
}

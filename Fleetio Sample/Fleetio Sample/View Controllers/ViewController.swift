//
//  ViewController.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/1/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    // Private Vars
    private var fuelEntries: [FIOFuelEntry]!
    private var listController: FuelEntryListViewController!
    private var mapController: FuelEntryMapViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up references to children
        setupChildViewControllers()
        
        fuelEntries = [FIOFuelEntry]()
        
        FIONetworkManager.shared.getFuelEntries(withSuccess: { (jsonArray) in
            for entry in jsonArray {
                let fuelEntry = FIOFuelEntry(withDictionary: entry)
                self.fuelEntries.append(fuelEntry)
            }
            
            DispatchQueue.main.async {
                self.updateFuelEntries()
            }
        }) { (error) in
            let alert = UIAlertController(title: "Uh oh!", message: "An error occurred while trying to get fuel entries. Please try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            print("[Fleet Sample - ViewController]: \(error)")
        }
    }

    
    // MARK: Private Functions
    
    private func setupChildViewControllers() {
        guard let viewControllers = viewControllers else {
            return
        }
        
        // Get reference to ListViewController
        if let listController = viewControllers[0] as? FuelEntryListViewController {
            self.listController = listController
        }
        
        // Get reference to MapViewController
        if let mapController = viewControllers[1] as? FuelEntryMapViewController {
            mapController.delegate = self
            self.mapController = mapController
        }
    }
    
    private func updateFuelEntries() {
        if listController != nil {
            listController.fuelEntries = self.fuelEntries
        }
        
        if mapController != nil {
            mapController.fuelEntries = self.fuelEntries
        }
    }
    
    private func presentPassiveAlert(withMessage message: String, alertType: PassiveAlertType = .positive) {
        let passiveAlertView = FIOPassiveAlertView(withMessage: message, alertType: alertType, forView: view)
        passiveAlertView.presentAlert()
    }
}


// MARK: FuelEntryMapViewController Delegate

extension ViewController: FuelEntryMapViewControllerDelegate {
    
    func fuelEntryMapViewController(viewController: FuelEntryMapViewController, receivedMappingErrorWithCount count: Int) {
        presentPassiveAlert(withMessage: "Unable to map \(count) fuel entries", alertType: .negative)
    }
    
}


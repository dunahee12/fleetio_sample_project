//
//  ViewController.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/1/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITabBarController {
    
    // Constants
    private let detailSegueIdentifier = "DetailSegue"
    
    // Private Vars
    private var listController: FuelEntryListViewController!
    private var mapController: FuelEntryMapViewController!
    private var selectedEntry: FIOFuelEntry?
    private var fuelEntries = [FIOFuelEntry]()
    private var fuelEntryPaginationCounter = 0

    
    // MARK: Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildViewControllers() // Set up references to children
        loadCoreDataEntries()
        fetchFuelEntries(withRefresh: true)
    }
    
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case detailSegueIdentifier:
            if let selectedEntry = selectedEntry {
                let detailVC = segue.destination as! FuelEntryDetailViewController
                detailVC.fuelEntry = selectedEntry
            }
            
        default:
            break
        }
    }

    
    // MARK: Private Functions
    
    private func setupChildViewControllers() {
        guard let viewControllers = viewControllers else {
            return
        }
        
        // Get reference to ListViewController
        if let listController = viewControllers[0] as? FuelEntryListViewController {
            listController.delegate = self
            self.listController = listController
        }
        
        // Get reference to MapViewController
        if let mapController = viewControllers[1] as? FuelEntryMapViewController {
            mapController.delegate = self
            self.mapController = mapController
        }
    }
    
    private func updateChildViewControllers() {
        listController.fuelEntries = self.fuelEntries
        mapController.fuelEntries = self.fuelEntries
    }

    private func presentPassiveAlert(withMessage message: String, alertType: PassiveAlertType = .positive) {
        let passiveAlertView: FIOPassiveAlertView = UIView.fromNib()
        passiveAlertView.autoDismissEnabled = true
        passiveAlertView.presentAlert(withMessage: message, alertType: alertType, forView: view)
    }
    
    private func fetchFuelEntries(withRefresh: Bool) {
        // Use passive alert as a 'loading indicator'
        let loadingAlert: FIOPassiveAlertView = UIView.fromNib()
        loadingAlert.showsLoader = true
        loadingAlert.presentAlert(withMessage: "Getting latest Fuel Entries", alertType: .positive, forView: view)
        
        // Sets page number for pagination
        fuelEntryPaginationCounter = withRefresh ? 1 : (fuelEntryPaginationCounter + 1)
        
        // Start API request
        FIONetworkManager.shared.getFuelEntries(forPage: fuelEntryPaginationCounter, withSuccess: { (jsonArray, doneLoading) in
            // Update coreData and refresh tables
            func finishLoading() {
                self.updateCoreData(withEntries: jsonArray)
                loadingAlert.hideAlert()
            }
            
            DispatchQueue.main.async {
                if withRefresh {
                    // Remove local objects and delete coreData entries
                    self.fuelEntries.removeAll()
                    self.deleteCoreData {
                        finishLoading()
                    }
                } else {
                    finishLoading()
                }
                
                // If last page was loaded, update UI
                if doneLoading {
                    self.listController.allEntriesLoaded = true
                }
            }
        }) { (error) in
            let alert = UIAlertController(title: "Uh oh!", message: "An error occurred while trying to get fuel entries. Please try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            print("[Fleet Sample - ViewController]: \(error)")
        }
    }
    
    private func updateCoreData(withEntries entries: [Dictionary<String, Any>]) {
        for entry in entries {
            let fuelEntry = FIOFuelEntry(context: FIOGlobal.shared.context)
            fuelEntry.populate(withDictionary: entry)
            self.fuelEntries.append(fuelEntry)
        }
        
        do {
            updateChildViewControllers()
            try FIOGlobal.shared.context.save()
        } catch(let error) {
            print("[Fleet Sample - ViewController]: Failed to save to CoreData with error - \(error.localizedDescription)")
        }
    }
    
    private func deleteCoreData(withCompletion completion: @escaping () -> Void) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FIOFuelEntry.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let persistentContainer = FIOGlobal.shared.appDelegate.persistentContainer
        
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
            completion()
        } catch(let error) {
            print("[Fleet Sample - ViewController]: Failed to delete CoreData entries with error - \(error.localizedDescription)")
        }
        
    }
    
    /**
     Loads saved entries before refreshing. Useful for offline mode
     */
    private func loadCoreDataEntries() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: FIOFuelEntry.coreDataEntityId)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try FIOGlobal.shared.context.fetch(request)
            self.fuelEntries = (result as! [FIOFuelEntry])
            updateChildViewControllers()
        } catch {
            print("[Fleet Sample - ViewController]: Failed to load CoreData with error - \(error.localizedDescription)")
        }
    }
}


// MARK: FuelEntryListViewController Delegate

extension ViewController: FuelEntryListViewControllerDelegate {
    
    func fuelEntryListViewController(viewController: FuelEntryListViewController, didSelectFuelEntry fuelEntry: FIOFuelEntry) {
        selectedEntry = fuelEntry
        performSegue(withIdentifier: detailSegueIdentifier, sender: self)
    }
    
    func fuelEntryListViewControllerRequestedMoreEntries(viewController: FuelEntryListViewController) {
        fetchFuelEntries(withRefresh: false)
    }
    
}


// MARK: FuelEntryMapViewController Delegate

extension ViewController: FuelEntryMapViewControllerDelegate {
    
    func fuelEntryMapViewController(viewController: FuelEntryMapViewController, receivedMappingErrorWithCount count: Int) {
        presentPassiveAlert(withMessage: "Unable to map \(count) fuel entries", alertType: .negative)
    }
    
    func fuelEntryMapViewController(viewController: FuelEntryMapViewController, didSelectFuelEntry fuelEntry: FIOFuelEntry) {
        selectedEntry = fuelEntry
        performSegue(withIdentifier: detailSegueIdentifier, sender: self)
    }
    
}


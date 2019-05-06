//
//  FuelEntryMapViewController.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/2/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import UIKit
import MapKit

// Subclass of map annotation that allows us to track the related fuel entry
class FIOFuelEntryAnnotation: MKPointAnnotation {
    
    var fuelEntry: FIOFuelEntry? {
        didSet {
            title = fuelEntry?.vehicleName ?? "Unavailable"
            subtitle = FIOGlobal.shared.dateToStringFormatter.string(from: fuelEntry?.date ?? Date())
            coordinate = CLLocationCoordinate2D(latitude: fuelEntry?.latitude ?? 0.0, longitude: fuelEntry?.longitude ?? 0.0)
        }
    }
    
}


protocol FuelEntryMapViewControllerDelegate: class {
    func fuelEntryMapViewController(viewController: FuelEntryMapViewController, receivedMappingErrorWithCount count: Int)
    func fuelEntryMapViewController(viewController: FuelEntryMapViewController, didSelectFuelEntry fuelEntry: FIOFuelEntry)
}

class FuelEntryMapViewController: UIViewController {
    
    // Public Vars
    public weak var delegate: FuelEntryMapViewControllerDelegate?
    public var fuelEntries: [FIOFuelEntry]! {
        didSet {
            populateMapView()
        }
    }
    
    // IBOutlet
    @IBOutlet weak var mapView: MKMapView!

    // Private Vars
    private var annotations: [MKAnnotation]!
    
    
    // MARK: Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup MapView
        annotations = [MKAnnotation]()
        populateMapView()
    }
    
    
    // MARK: Private Functions
    
    private func populateMapView() {
        if mapView == nil {
            return
        }
        
        // Clear previous annotations
        mapView.delegate = self
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        
        var errorCount = 0
        
        // Populate annotations
        for entry in fuelEntries {
            // If the lat and long are both 0, we can assume
            // that the entry is unmapple and continue to next entry
            if entry.latitude == 0 && entry.longitude == 0 {
                errorCount += 1
                continue
            }
            
            let annotation = FIOFuelEntryAnnotation()
            annotation.fuelEntry = entry
            
            mapView.addAnnotation(annotation)
            annotations.append(annotation) // Append to local annoation array
        }
        
        showMappingError(withCount: errorCount)
    }
    
    /**
     Presents user with an error message about entries not containing coordinates
     
     - Parameter count: Number of entries without coordinates
     */
    private func showMappingError(withCount count: Int) {
        delegate?.fuelEntryMapViewController(viewController: self, receivedMappingErrorWithCount: count)
    }

}


// MARK: MKMapView Delegate

extension FuelEntryMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let fuelAnnotation = view.annotation as? FIOFuelEntryAnnotation, let fuelEntry = fuelAnnotation.fuelEntry {
            delegate?.fuelEntryMapViewController(viewController: self, didSelectFuelEntry: fuelEntry)
        }
    }
    
}

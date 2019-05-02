//
//  FuelEntryMapViewController.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/2/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import UIKit
import MapKit

class FuelEntryMapViewController: UIViewController {
    
    // Public Vars
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
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        
        // Populate annotations
        for entry in fuelEntries {
            let annotation = MKPointAnnotation()
            annotation.title = entry.vehicleName
            annotation.subtitle = entry.referenceNumber
            annotation.coordinate = CLLocationCoordinate2D(latitude: entry.latitude, longitude: entry.longitude)
            mapView.addAnnotation(annotation)
            
            annotations.append(annotation)
        }
    }

}

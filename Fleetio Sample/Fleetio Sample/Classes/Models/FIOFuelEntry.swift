//
//  FIOFuelEntry.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/1/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import Foundation
import CoreData

class FIOFuelEntry: NSManagedObject {
//
    // Public Vars
    @NSManaged public var date: Date
    @NSManaged public var vehicleName: String
    @NSManaged public var costPerMile: Double
    @NSManaged public var usageInMiles: Double
    @NSManaged public var gallons: Double
    @NSManaged public var fuelTypeName: String
    @NSManaged public var pricePerGallon: Double
    @NSManaged public var vendor: String
    @NSManaged public var referenceNumber: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    
    // I'm not 100% sure on this, but this is what I am using to calculate
    // the 'cost' field, as described in the project instructions
    public var cost: Double {
        return costPerMile * usageInMiles
    }
    
    // Constants
    public static let coreDataEntityId = "FIOFuelEntry"


    // MARK: Public Functions
    
   public func populate(withDictionary dictionary: Dictionary<String, Any>) {
        // Parse date, or use current if nil
        if let dateString = dictionary["date"] as? String, let dateValue = FIOGlobal.shared.stringToDateFormatter.date(from: dateString) {
            date = dateValue
        } else {
            date = Date()
        }
        
        vehicleName = (dictionary["vehicle_name"] as? String) ?? "Unavailable"
        usageInMiles = (dictionary["usage_in_mi"] as? Double) ?? 0.00
        costPerMile = (dictionary["cost_per_mi"] as? Double) ?? 0.00
        gallons = (dictionary["us_gallons"] as? Double) ?? 0.00
        fuelTypeName = (dictionary["fuel_type_name"] as? String) ?? "Unavailable"
        pricePerGallon = (dictionary["price_per_volume_unit"] as? Double) ?? 0.00
        vendor = (dictionary["vendor_name"] as? String) ?? "Unavailable"
        referenceNumber = (dictionary["reference"] as? String) ?? "Unavailable"
        
        if let geolocationDict = dictionary["geolocation"] as? Dictionary<String, Any> {
            latitude = (geolocationDict["latitude"] as? Double) ?? 0.00
            longitude = (geolocationDict["longitude"] as? Double) ?? 0.00
        } else {
            latitude = 0.00
            longitude = 0.00
        }
    }
    
}


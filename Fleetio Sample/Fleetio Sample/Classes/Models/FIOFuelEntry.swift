//
//  FIOFuelEntry.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/1/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import Foundation

struct FIOFuelEntry {
    
    var date: Date
    var vehicleName: String
    var cost: String
    var costPerMile: Double
    var gallons: Double
    var fuelTypeName: String
    var pricePerGallon: Double
    var vendor: String
    var referenceNumber: String
    var latitude: Double
    var longitude: Double
    
    init(withDictionary dictionary: Dictionary<String, Any>) {
        date = (dictionary["date"] as? Date) ?? Date()
        vehicleName = (dictionary["vehicle_name"] as? String) ?? "Unavailable"
        cost = (dictionary["cost_per_mi"] as? String) ?? "Unavailable"
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

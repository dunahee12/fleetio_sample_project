//
//  FIOGlobal.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/3/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import UIKit
import CoreData

class FIOGlobal: NSObject {
    
    // Singleton
    public static let shared = FIOGlobal()
    
    // Public Vars
    public let stringToDateFormatter: DateFormatter!
    public let dateToStringFormatter: DateFormatter!
    public let appDelegate: AppDelegate!
    public let context: NSManagedObjectContext!
    
    
    // MARK: Initializers
    
    override init() {
        // CoreData related object
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        context = appDelegate.persistentContainer.viewContext
        
        // Date formatter for converting dates to string
        dateToStringFormatter = DateFormatter()
        dateToStringFormatter.dateFormat = "MM/dd/yyyy"
        dateToStringFormatter.locale = Locale(identifier: "en_US")
        
        // Date formatter for converting String to Date from server
        stringToDateFormatter = DateFormatter()
        stringToDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        stringToDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    }
    
}

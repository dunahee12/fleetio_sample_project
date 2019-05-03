//
//  FIOGlobal.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/3/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import UIKit

class FIOGlobal: NSObject {
    
    // Singleton
    public static let shared = FIOGlobal()
    
    // Public Vars
    public let stringToDateFormatter: DateFormatter!
    public let dateToStringFormatter: DateFormatter!
    
    
    // MARK: Initializers
    
    override init() {
        dateToStringFormatter = DateFormatter()
        dateToStringFormatter.dateFormat = "MM/dd/yyyy"
        dateToStringFormatter.locale = Locale(identifier: "en_US")
        
        stringToDateFormatter = DateFormatter()
        stringToDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        stringToDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    }
    
}

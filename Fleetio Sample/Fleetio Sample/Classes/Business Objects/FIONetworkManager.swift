//
//  FIONetworkManager.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/1/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import UIKit

class FIONetworkManager: NSObject {
    
    // Singleton
    public static let shared = FIONetworkManager()
    
    // Private Vars
    private var session: URLSession!
    
    
    // MARK: Initializers
    
    override init() {
        session = URLSession.shared
    }
    
    
    // MARK: Public Functions
    
    public func getFuelEntries(withSuccess success: @escaping (NSArray) -> Void, failure: @escaping (Error) -> Void) {
        // Create request from URL
        let urlString = "https://secure.fleetio.com/api/v1/fuel_entries"
        guard let request = createAuthenticatedRequest(withUrlString: urlString) else {
            return
        }
        
        // Perform request
        let task = session.dataTask(with: request) { (data, response, error) in
            // If error, handle and return
            if let error = error {
                failure(error)
                return
            }
            
            // Parse json, if data is returned
            if let jsonData = data {
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                    success(jsonArray)
                } catch(let error) {
                    failure(error)
                }
            }
        }
        task.resume()
    }
    
    
    // MARK: Private Functions
    
    private func createAuthenticatedRequest(withUrlString urlString: String) -> URLRequest? {
        // Safely unwrap the url from string
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        // Set auth tokens for new request
        var requeset = URLRequest(url: url)
        requeset.setValue("Bearer 0bd86b93e8b27ea5408e4b4590efadecce9ccf75533dc7e2cde6e328e394668a", forHTTPHeaderField: "Authorization")
        requeset.setValue("798819214b", forHTTPHeaderField: "Account-Token")
        
        return requeset
    }

}

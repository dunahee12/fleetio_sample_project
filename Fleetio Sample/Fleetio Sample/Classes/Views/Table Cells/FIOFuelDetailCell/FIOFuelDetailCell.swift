//
//  FIOFuelDetailCell.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/2/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import UIKit

class FIOFuelDetailCell: UITableViewCell {
    
    // Public Vars
    public static let cellIdentifier = "FIOFuelDetailCell"
    
    // IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    
    // MARK: Lifecycle Functions
    
    override func awakeFromNib() {
        selectionStyle = .none
    }

    
    // MARK: Public Functions
    
    public func bind(withTitle title: String, value: Any) {
        lblTitle.text = title
        lblValue.text = "\(value)"
    }
    
}

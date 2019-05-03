//
//  UIViewExtension.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/3/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}

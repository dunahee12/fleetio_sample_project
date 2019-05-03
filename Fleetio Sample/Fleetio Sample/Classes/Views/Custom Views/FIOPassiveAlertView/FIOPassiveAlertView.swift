//
//  FIOPassiveAlertView.swift
//  Fleetio Sample
//
//  Created by Jake Dunahee on 5/2/19.
//  Copyright © 2019 Jake Dunahee. All rights reserved.
//

import UIKit

// Enums
enum PassiveAlertType {
    case positive
    case neutral
    case negative
    
    var colorValue: UIColor {
        get {
            switch self {
            case .positive: return UIColor.fleetioGreen()
            case .neutral: return UIColor(withHexSting: "#DF9D43")
            case .negative: return UIColor(withHexSting: "#E27A7A")
            }
        }
    }
}

class FIOPassiveAlertView: UIView {
    
    // Public Var
    public var autoDismissEnabled = false
    public var showsLoader = false
    
    // IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    // Private Vars
    private let alertHeight: CGFloat = 100
    
    
    // MARK: Public Functions
    
    public func presentAlert(withMessage message: String, alertType: PassiveAlertType, forView view: UIView) {
        self.frame = CGRect(x: 0, y: -alertHeight, width: view.frame.width, height: alertHeight)
        view.addSubview(self)
        
        // Set values
        lblTitle.text = message
        backgroundColor = alertType.colorValue
        loader.isHidden = !showsLoader
        
        // Animate alert into view
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.frame.size)
        }) { (complete) in
            if self.autoDismissEnabled {
                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { (timer) in
                    self.hideAlert()
                })
            }
        }
    }
    
    public func hideAlert() {
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(origin: CGPoint(x: 0, y: -self.alertHeight), size: self.frame.size)
        }) { (complete) in
            self.removeFromSuperview()
        }
    }
    
}

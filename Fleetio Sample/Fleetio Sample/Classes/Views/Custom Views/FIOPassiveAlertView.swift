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
            case .positive: return UIColor(withHexSting: "#24C26D")
            case .neutral: return UIColor(withHexSting: "#DF9D43")
            case .negative: return UIColor(withHexSting: "#E27A7A")
            }
        }
    }
}

class FIOPassiveAlertView: UIView {
    
    // Private Vars
    private var lblTitle: UILabel!
    private let alertHeight: CGFloat = 70
    
    
    // MARK: Initializers
    
    init(withMessage message: String, alertType: PassiveAlertType, forView view: UIView) {
        let frame = CGRect(x: 0, y: -alertHeight, width: view.frame.width, height: alertHeight)
        super.init(frame: frame)
        view.addSubview(self)
        
        setup(withTitle: message, alertType: alertType)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(withTitle: "No message", alertType: .positive)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(withTitle: "No message", alertType: .positive)
    }
    
    
    // MARK: Public Functions
    
    public func presentAlert() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.frame.size)
        }) { (complete) in
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { (timer) in
                self.hideAlert()
            })
        }
    }
    
    
    // MARK: Private Functions
    
    private func hideAlert() {
        UIView.animate(withDuration: 1.0, animations: {
            self.frame = CGRect(origin: CGPoint(x: 0, y: -self.alertHeight), size: self.frame.size)
        }) { (complete) in
            self.removeFromSuperview()
        }
    }
    
    private func setup(withTitle title: String, alertType: PassiveAlertType) {
        lblTitle = UILabel()
        lblTitle.text = title
        lblTitle.textColor = UIColor.white
        lblTitle.adjustsFontSizeToFitWidth = true
        lblTitle.font = UIFont.systemFont(ofSize: 18, weight: .light)
        
        let padding: CGFloat = 20
        lblTitle.frame = CGRect(x: padding, y: padding, width: frame.width - padding, height: frame.height - padding)
        addSubview(lblTitle)
        
        backgroundColor = alertType.colorValue
    }

}

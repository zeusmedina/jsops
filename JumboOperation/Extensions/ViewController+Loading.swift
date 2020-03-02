//
//  ViewControllerExtensions.swift
//  JumboOperation
//
//  Created by zeus medina on 3/1/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import UIKit

var globalSpinner : UIView?
 
extension UIViewController {
    func showSpinner() {
        let spinnerView = UIView.init(frame: self.view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicator)
            self.view.addSubview(spinnerView)
        }
        
        globalSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            globalSpinner?.removeFromSuperview()
            globalSpinner = nil
        }
    }
}

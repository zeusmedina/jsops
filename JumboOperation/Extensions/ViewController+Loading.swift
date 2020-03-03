//
//  ViewControllerExtensions.swift
//  JumboOperation
//
//  Created by zeus medina on 3/1/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import UIKit

protocol LoadingPresentable {
    var activityIndicatorView: UIActivityIndicatorView { get }
    func showSpinner()
    func hideSpinner()
}
 
extension LoadingPresentable where Self: UIViewController {
    func showSpinner() {
        self.activityIndicatorView.style = .large
        self.activityIndicatorView.color = .black
        self.activityIndicatorView.startAnimating()
        self.activityIndicatorView.center = self.view.center
        
        DispatchQueue.main.async {
            self.view.addSubview(self.activityIndicatorView)
        }
        
    }
    
    func hideSpinner() {
        DispatchQueue.main.async {
            self.activityIndicatorView.removeFromSuperview()
        }
    }
}

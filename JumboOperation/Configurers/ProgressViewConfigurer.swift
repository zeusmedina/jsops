//
//  ProgressViewConfigurer.swift
//  JumboOperation
//
//  Created by zeus medina on 2/29/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import UIKit
/// Configurers help keep views and models decoupled leading to increased reusability of views and testability
struct ProgressViewConfigurer {
    
    /**
     Configures and returns a UIProgressView with width and height constraints applied
    */
    static func configureDefault() -> UIProgressView {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .purple
        progressView.trackTintColor = .lightGray
        progressView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        return progressView
    }
    
    /**
     Configures a provided progressView... updates a state corresponding to the message
     - parameter progressView: The UIProgressView to update
     - parameter message: The message containing presentation logic for the progress view
    */
    static func configure(progressView: UIProgressView, with message: Message) {
        if let state = message.state, state == .error {
            progressView.progressTintColor = .red
            return
        }
        // Didn't recieve an error
        switch message.message {
        case .progress:
            guard let progress = message.progress else { return}
            let progressValue = Float(Float(progress) / 100)
            progressView.setProgress(progressValue, animated: true)
        case .completed:
            progressView.progressTintColor = .green
            progressView.trackTintColor = .green
            progressView.setProgress(1.0, animated: true)
        }
    }
}

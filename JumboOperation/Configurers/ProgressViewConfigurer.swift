//
//  ProgressViewConfigurer.swift
//  JumboOperation
//
//  Created by zeus medina on 2/29/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import UIKit
// Configurers help keep views and models decoupled leading to increased reusability of views and testability
struct ProgressViewConfigurer {
    
    /// Configures a default progress view
    static func configureDefault() -> UIProgressView {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .purple
        progressView.trackTintColor = .lightGray
        progressView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        return progressView
    }
    
    /// Updates the progress view according to a Message
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

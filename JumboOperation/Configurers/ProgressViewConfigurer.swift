//
//  ProgressViewConfigurer.swift
//  JumboOperation
//
//  Created by zeus medina on 2/29/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import UIKit
struct ProgressViewConfigurer {
    static func configureDefault() -> UIProgressView {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .purple
        progressView.trackTintColor = .lightGray
        progressView.progress = 0.25
        progressView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        return progressView
    }
    
    static func configure(progressView: UIProgressView, with message: Message) {
        if let state = message.state, state == .error {
            progressView.progressTintColor = .red
            return
        }
        
        // Didn't recieve an error
        switch message.message {
        case .progress:
            guard let progress = message.progress else { return}
            let progressValue = Float(progress / 100)
            progressView.setProgress(progressValue, animated: true)
        case .completed:
            progressView.progressTintColor = .green
            progressView.setProgress(1.0, animated: true)
        }
    }
}

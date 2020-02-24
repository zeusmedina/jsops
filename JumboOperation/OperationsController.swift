//
//  OperationsController.swift
//  JumboOperation
//
//  Created by zeus medina on 2/23/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation

// TODO: protocol?
// This class is responsible for initializing our web view wrapper and listening to updates via delegate
// Also "tells" the view what to do
// Some may prefer view model naming or "presenter" depending on the architecture
final class OperationsController {
    
    // Ideally we want our view layer to be as "dumb" as possible... I've recently started occassionaly backing views with a protocol
    // Keeps business logic decoupled from UIKit and this code could be shared with for example a Mac OS app
    // Also allows mocking out the view to write unit tests... a potentially reasonable compromise if XCUI tests aren't being written
    weak var viewDelegate: OperationView?
    
    private var webViewWrapper: WebViewWrapper?
    // download the js file (loading state during this -> error if it fails)
    // inject this file into our webview wrapper
    
    init() {
        downloadJSFile()
    }
    
    func beginNewOperation() {
        guard let wrapper = webViewWrapper else { return }
        wrapper.startNewOperation(id: "0")
    }
    
    // TODO: make this testable
    private func downloadJSFile() {
        guard let url = URL(string: Constants.javascriptFileURL) else {
            // error
            return
        }

        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            //TODO: handle error
            // make sure to do ui updates on the main thread
            if let localURL = localURL {
                if let jsFile = try? String(contentsOf: localURL) {
                    DispatchQueue.main.async {
                        self.webViewWrapper = WebViewWrapper(jsScript: jsFile)
                    }
                }
            }
        }

        task.resume()
    }
    
    // MARK: - String Constants
    private enum Constants {
        static let javascriptFileURL = "https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js"
    }
}

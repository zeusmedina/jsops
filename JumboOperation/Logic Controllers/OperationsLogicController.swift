//
//  OperationsLogicController.swift
//  JumboOperation
//
//  Created by zeus medina on 2/23/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation
import WebKit
import os.log

// TODO: protocol?
// This class is responsible for initializing our web view wrapper and recieving messages from our webview
// Also "tells" the view what to do... some may prefer view model naming or "presenter" depending on the architecture/dev team
final class OperationsLogicController: NSObject {
    
    private let fileDownloader: FileDownloader
    private let decoder = JSONDecoder()
    
    // Exposed for testing... ideally this is passed in the initializer
    var webViewWrapper: JavascriptExecutor?
    
    // Internal index used to keep track of our operations... used at the id of our messages
    // NOTE: In practice id's should probably be a random generated string
    // Exposed for testing
    private(set) var index = 1
    
    // Ideally we want our view layer to be as "dumb" as possible... I've recently started occassionaly backing views with a protocol
    // Keeps business logic decoupled from UIKit and this code could be shared with for example a Mac OS app
    // Also allows mocking out the view to write unit tests... a potentially reasonable compromise if XCUI tests aren't being written
    weak var viewDelegate: OperationView?
    
    init(fileDownloader: FileDownloader) {
        self.fileDownloader = fileDownloader
        super.init()
    }
    
    /**
     Sets the delegate and begins downloading JS file. Also informs the view to begin showing the loading state
     - parameter view: An OperationView to set as the delegate
     */
    func attach(view: OperationView) {
        viewDelegate = view
        viewDelegate?.showLoadingState()
        downloadJSFile()
    }
    
    /// Begins a new operation, increments our index, and tells our view to display a new progress view
    func addOperationTapped() {
        if index == 5 {
            viewDelegate?.presentAlert(with: Constants.maxOperationsReached)
            return
        }
        guard let wrapper = webViewWrapper else { return }
        wrapper.startNewOperation(indexID: index) { [weak self] error in
            guard let self = self else { return }
            self.viewDelegate?.presentAlert(with: Constants.startError)
        }
        index += 1
        viewDelegate?.insertNewProgressView()
    }
    
    /// Fetches our javascript string represenation from a URL
    /// TODO: add ability to retry 
    private func downloadJSFile() {
        fileDownloader.downloadFile(from: Constants.javascriptFileURL) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .failure:
                    self.viewDelegate?.stopLoadingState()
                    self.viewDelegate?.presentAlert(with: Constants.error)
                case .success(let jsFile):
                    // Starts downloading our JS file
                    self.webViewWrapper = WebViewWrapper(jsScript: jsFile,
                                                         messageHandler: self,
                                                         navigationDelegate: self)
                }
            }
        }

    }
    
    // MARK: - String Constants
    private enum Constants {
        static let javascriptFileURL = "https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js"
        static let error = "Oops... looks like there was an error"
        static let startError = "There was an error starting the operation"
        static let maxOperationsReached = "Limit of 4 operations has been reached"
    }
}

extension OperationsLogicController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        DispatchQueue.main.async {
            guard let jsonString = message.body as? String,
                let data = jsonString.data(using: .utf8),
                let messageModel = try? self.decoder.decode(Message.self, from: data)
            else {
                self.viewDelegate?.presentAlert(with: Constants.error)
                os_log("Error decoding a message", log: .default, type: .error)
                return
            }
            self.viewDelegate?.updateProgressView(at: Int(messageModel.id), with: messageModel)
        }
    }
}

/// Loading of our webview completed we're ready to show the default UI
/// Note that I'm assuming the load was successful here... I'd add additional error handling
extension OperationsLogicController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.viewDelegate?.showDefaultState()
        self.viewDelegate?.stopLoadingState()
    }
}

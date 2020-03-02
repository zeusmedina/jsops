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
    private var webViewWrapper: WebViewWrapper?
    
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
        downloadJSFile()
    }
    
    // MARK: - Public Functions
    
    // Begins a new operation and increments our index
    func addOperationTapped() {
        guard let wrapper = webViewWrapper else { return }
        wrapper.startNewOperation(indexID: index)
        index += 1
        viewDelegate?.insertNewProgressView()
    }
    

    
    // TODO: make this more testable
    private func downloadJSFile() {
        fileDownloader.downloadFile(from: Constants.javascriptFileURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                self.viewDelegate?.stopLoadingState()
                self.viewDelegate?.presentAlert(with: Constants.error)
            case .success(let jsFile):
                // Starts
                self.webViewWrapper = WebViewWrapper(jsScript: jsFile,
                                                     messageHandler: self,
                                                     navigationDelegate: self)
            }
        }

    }
    
    // MARK: - String Constants
    private enum Constants {
        static let javascriptFileURL = "https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js"
        static let error = "Oops... looks like there was an error downloading JS file"
    }
}

extension OperationsLogicController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // We can probably drop this dispatch... I initially thought that evaluate js ran on a background thread
        DispatchQueue.main.async {
            // TODO: handle guard - we'd probably want to show an alert OR set our progress bar to red
            guard let jsonString = message.body as? String, let data = jsonString.data(using: .utf8) else { return }
            do {
                let messageModel = try self.decoder.decode(Message.self, from: data)
                print(messageModel)
                self.viewDelegate?.updateProgressView(at: Int(messageModel.id), with: messageModel)
            } catch {
                os_log("Error decoding a message", log: .default, type: .error)
            }
            
        }
        
    }
}

/// Loading of our webview completed we're ready to show the default UI
/// Note that I'm assuming the load was succesful here... I'd add additional error handling
extension OperationsLogicController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.viewDelegate?.stopLoadingState()
    }
}

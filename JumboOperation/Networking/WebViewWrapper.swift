//
//  WebViewWrapper.swift
//  JumboOperation
//
//  Created by zeus medina on 2/23/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation
import WebKit

/// A simple wrapper around WKWebView with a convenience function for executing javascript
class WebViewWrapper: NSObject {
    // This is unfortunately a var and gets intialized twice
    // Need to find a way around this... but the webview requires a content controller that sets self as the delegate
    // but self doesn't exist prior to initialization... come back and fix this if time
    private var webView: WKWebView
    private let jsScript: String
    
    // TODO: move config into it's own function? Test? - this init is a bit large and obfuscates the webview loading
    init(jsScript: String,
         messageHandler: WKScriptMessageHandler,
         navigationDelegate: WKNavigationDelegate) {
        self.webView = WKWebView()
        self.jsScript = jsScript
        super.init()
        let script = WKUserScript(source: jsScript,
                                  injectionTime: .atDocumentStart,
                                  forMainFrameOnly: true)
        let contentController = WKUserContentController()
        contentController.addUserScript(script)
        contentController.add(messageHandler, name: Constants.jumbo)

        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = navigationDelegate
        // Curious if there's another way to evaluate JS without loading a site... I looked into JSContext but that didn't appear to provide what I needed
        if let url = URL(string: Constants.codingChallengeURL) {
            webView.load(URLRequest(url: url))
         }
    }
    
    /**
     Evaluates a javascript operation... discarable result for unit testing purposes
     - parameter indexID: An indentifier for the operation
     - parameter completionHandler: Gets invoked if an error occurs
     */
    @discardableResult func startNewOperation(indexID: Int, completionHandler: @escaping (Error) -> Void) -> String {
        let id = String(indexID)
        let operationFunctionCall = "startOperation('\(id)')"
        /// Documentation states completion always runs on main thread
        webView.evaluateJavaScript(operationFunctionCall) { (result, error) in
            if let error = error {
                    completionHandler(error)
            }
        }
        return operationFunctionCall
    }
    
    private enum Constants {
        static let jumbo = "jumbo"
        static let codingChallengeURL = "https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js"
        static let queue = "jumbo.concurrent.queue"
    }
}

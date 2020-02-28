//
//  WebViewWrapper.swift
//  JumboOperation
//
//  Created by zeus medina on 2/23/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation
import WebKit


class WebViewWrapper: NSObject {
    
    private let concurrentQueue = DispatchQueue(label: Constants.queue)
    
    // This is unfortunately a var and gets intialized twice
    // Need to find a way around this... but the webview requires a content controller that sets self as the delegate
    // but self doesn't exist prior to initialization... come back and fix this if time
    // NOTE: Evaluating the source script instead of using a content controller would likely remedy this. However I wouldn't want
    private var webView: WKWebView
    private let jsScript: String
    init(jsScript: String) {
        self.webView = WKWebView()
        self.jsScript = jsScript
        super.init()
        
        // TODO: move config into it's own function? Test?
        let script = WKUserScript(source: jsScript, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        // not sure whether to add the script here or simply evaluate it
        let contentController = WKUserContentController()
        contentController.addUserScript(script)
        contentController.add(self, name: Constants.jumbo)

        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        

        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        if let url = URL(string: Constants.codingChallengeURL) {
            webView.load(URLRequest(url: url))
         }
    }
    
    // TODO: write a function that concats the 2 strings and UNIT TEST IT
    func startNewOperation(id: String) {
        let operationFunctionCall = "startOperation(\(id))"
        webView.evaluateJavaScript(operationFunctionCall) { (result, error) in
            if error != nil {
                print(result)
            }
        }
    }
    
    
    private enum Constants {
        static let jumbo = "jumbo"
        static let codingChallengeURL = "https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js"
        static let queue = "jumbo.concurrent.queue"
    }
}

extension WebViewWrapper: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
    }
}

extension WebViewWrapper: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.startNewOperation(id: "2")
    }
}

//
//  WebViewWrapperTests.swift
//  JumboOperationTests
//
//  Created by zeus medina on 3/1/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import XCTest
@testable import JumboOperation

class WebViewWrapperTests: XCTestCase {

    func testStartNewOperation() {
        let logicController = OperationsLogicController(fileDownloader: MockSuccessFileDownloader())
        let wrapper = WebViewWrapper(jsScript: "javascript",
                                     messageHandler: logicController,
                                     navigationDelegate: logicController)
        let operation = wrapper.startNewOperation(indexID: 2) { error in
            return
        }
        XCTAssertEqual("startOperation('2')", operation)
    }

}

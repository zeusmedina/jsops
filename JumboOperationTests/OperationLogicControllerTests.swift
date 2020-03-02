//
//  OperationLogicControllerTests.swift
//  JumboOperationTests
//
//  Created by zeus medina on 3/1/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import XCTest
@testable import JumboOperation

fileprivate class JSExecutorMock: JavascriptExecutor {
    @discardableResult func startNewOperation(indexID: Int, completionHandler: @escaping (Error) -> Void) -> String {
        return "startOperation()"
    }
}

class OperationLogicControllerTests: XCTestCase {
    
    func testAddOperationTapped() {
        let logicController = OperationsLogicController(fileDownloader: MockSuccessFileDownloader())
        logicController.webViewWrapper = JSExecutorMock()
        logicController.attachView(view: MockOperationView())
        
        // Index should be 1 upon initialization
        XCTAssertEqual(1, logicController.index)
        logicController.addOperationTapped()
        // Index should increment up to 5
        XCTAssertEqual(2, logicController.index)
        
        
    }

}

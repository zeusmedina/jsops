//
//  OperationViewTests.swift
//  OperationViewTests
//
//  Created by zeus medina on 2/23/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import XCTest
@testable import JumboOperation

internal class MockOperationView: OperationView {
    let showDefaultStateExp = XCTestExpectation(description: "Show default state called")
    let showLoadingStateExp = XCTestExpectation(description: "Show loading state called")
    let stopLoadingStateExp = XCTestExpectation(description: "Stop loading state called")
    let insertNewProgressViewExp = XCTestExpectation(description: "New progress view was inserted")
    let updateProgressViewExp = XCTestExpectation(description: "Progress view was updated")
    let presentAlertExp = XCTestExpectation(description: "Alert was presented")
    
    func showDefaultState() {
        showDefaultStateExp.fulfill()
    }
    
    func showLoadingState() {
        showLoadingStateExp.fulfill()
    }
    
    func stopLoadingState() {
        stopLoadingStateExp.fulfill()
    }
    
    func insertNewProgressView() {
        insertNewProgressViewExp.fulfill()
    }
    
    func updateProgressView(at index: Int?, with message: Message) {
        updateProgressViewExp.fulfill()
    }
    
    func presentAlert(with text: String) {
        presentAlertExp.fulfill()
    }
}

class OperationViewTests: XCTestCase {
    
    fileprivate let successMockFleDownloader = MockSuccessFileDownloader()
    fileprivate let errorMockFileDownloader = MockErrorFileDownloader()
    fileprivate var viewMock = MockOperationView()
    
    /// When the app launches, the loading state should start, then upon succesful download of JS file
    /// we should stop the loading state and show the default state
    func testAppLaunchStateSuccess() {
        let logicController = OperationsLogicController(fileDownloader: successMockFleDownloader)
        logicController.attachView(view: viewMock)
        
        let expectations = [viewMock.showLoadingStateExp,
                            viewMock.showDefaultStateExp,
                            viewMock.stopLoadingStateExp]
        wait(for: expectations, timeout: 10)
    }
    
    /// If downloading our JS file fails, we should prsent an alert
    func testAppLaunchStateError() {
        let logicController = OperationsLogicController(fileDownloader: errorMockFileDownloader)
        logicController.attachView(view: viewMock)
        
        let expectations = [viewMock.showLoadingStateExp,
                            viewMock.presentAlertExp,
                            viewMock.stopLoadingStateExp]
        wait(for: expectations, timeout: 10)

    }

}

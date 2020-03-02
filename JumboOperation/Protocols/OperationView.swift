//
//  OperationView.swift
//  JumboOperation
//
//  Created by zeus medina on 3/1/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation

protocol OperationView: class {
    func showDefaultState()
    func showLoadingState()
    func stopLoadingState()
    func insertNewProgressView()
    func updateProgressView(at index: Int?, with message: Message)
    func presentAlert(with text: String)
}

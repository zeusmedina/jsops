//
//  JavascriptExecutor.swift
//  JumboOperation
//
//  Created by zeus medina on 3/1/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import Foundation

protocol JavascriptExecutor {
    @discardableResult func startNewOperation(indexID: Int, completionHandler: @escaping (Error) -> Void) -> String
}

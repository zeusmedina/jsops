//
//  OperationsViewController.swift
//  JumboOperation
//
//  Created by zeus medina on 2/23/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import UIKit

protocol OperationView: class {
    
}

class OperationsViewController: UIViewController, OperationView {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        let operationsController = OperationsLogicController()
    }


}


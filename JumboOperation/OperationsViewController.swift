//
//  OperationsViewController.swift
//  JumboOperation
//
//  Created by zeus medina on 2/23/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import UIKit

protocol OperationView: class {
    func updateLabel(text: String)
}

class OperationsViewController: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "label"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        let operationsController = OperationsLogicController()
        operationsController.viewDelegate = self
        initUI()
    }
    
    private func initUI() {
        view.addSubview(label)
        let constaints: [NSLayoutConstraint] = [
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constaints)
    }

}

extension OperationsViewController: OperationView {
    func updateLabel(text: String) {
        label.text = text
    }
}


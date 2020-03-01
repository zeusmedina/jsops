//
//  OperationsViewController.swift
//  JumboOperation
//
//  Created by zeus medina on 2/23/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import UIKit

protocol OperationView: class {
    func showLoadingState()
    func stopLoadingState()
    func insertNewProgressView()
    func updateProgressView(at index: Int?, with message: Message)
    func presentAlert(with text: String)
}

/// Allows users to initiate a new operation and observe the operation's progress
class OperationsViewController: UIViewController {
    
    
    let logicController = OperationsLogicController()
    
    // For simplicity I'm configuring all of my views within the VC
    // Configuration of views can be extracted to a dedicated object to help with testing and decoupling of logic
    
    // Stack view to hold our button and loading bars
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var addOperationButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.addOperation, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(addOperationButtonTapped), for: .touchDown)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        logicController.viewDelegate = self
        setupViews()
    }
    
    // Inform our logic controller that the button was tapped
    @objc func addOperationButtonTapped() {
        logicController.addOperationTapped()
    }
    
    func setupViews() {
        view.addSubview(stackView)
        let constaints: [NSLayoutConstraint] = [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constaints)
        stackView.addArrangedSubview(addOperationButton)
    }
    
    // Creates a new loading bar view and inserts it into our stack view
    func addNewLoadingBar() {
        
    }
    
    private enum Constants {
        static let addOperation = "Add operation"
    }

}
// MARK: - Operation View Conformance (User Interface changes)
// A state machine backed by some enum would be my usual approach here, the enums can have some associated values if needed
// Then we'd just have a function like render(state: State)
extension OperationsViewController: OperationView {
    func showLoadingState() {
        return
    }
    
    func stopLoadingState() {
        return
    }
    
    func presentAlert(with text: String) {
        return
    }
    
    // Considered passing in an index param
    func insertNewProgressView() {
        let progressView = ProgressViewConfigurer.configureDefault()
        stackView.addArrangedSubview(progressView)
    }
    
    func updateProgressView(at index: Int?, with message: Message) {
        guard let index = index, let progressView = stackView.arrangedSubviews[index] as? UIProgressView else { return }
        ProgressViewConfigurer.configure(progressView: progressView, with: message)
    }
    
}



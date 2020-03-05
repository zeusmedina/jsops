//
//  OperationsViewController.swift
//  JumboOperation
//
//  Created by zeus medina on 2/23/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import UIKit

/// Allows users to initiate a new operation and observe the operation's progress
class OperationsViewController: UIViewController, LoadingPresentable {
    
    
    let logicController = OperationsLogicController(fileDownloader: ConcreteFileDownloader())
    // For simplicity I'm configuring all of my views within the VC
    // Configuration of views can be extracted to a dedicated object to help with testing and decoupling of logic
    
    // Conformance to LoadingPresentable requires a UIActivityIndicatorView
    var activityIndicatorView = UIActivityIndicatorView()
    
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
        logicController.attach(view: self)
    }
    
    /// Inform our logic controller that the button was tapped
    @objc func addOperationButtonTapped() {
        logicController.addOperationTapped()
    }
    
    /// Setup our default layout 
    private func setupViews() {
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
    
    private enum Constants {
        static let addOperation = "Add operation"
    }

}
// MARK: - Operation View Conformance (User Interface changes)
// A state machine backed by some enum would be my usual approach here, the enums can have some associated values if needed
// Then we'd just have a function like render(state: State)
extension OperationsViewController: OperationView {
    func showDefaultState() {
        self.setupViews()
    }
    func showLoadingState() {
        self.showSpinner()
    }
    
    func stopLoadingState() {
        self.hideSpinner()
    }
    
    // TODO: move configuration of alert elsewhere
    func presentAlert(with text: String) {
        let alert = UIAlertController(title: nil,
                                      message: text,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.logicController.attach(view: self)
        }))
        self.present(alert, animated: true)
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



//
//  ViewController.swift
//  UIKit_Marathon_5
//
//  Created by @Lfgdsa on 11/13/24. 
//  Copyright (c) 2024 Eugene Babenko.
//

import UIKit

class ViewController: UIViewController {

    private lazy var button: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("Present", for: .normal)
        button.addTarget(self, action: #selector(showPopover), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private lazy var popoverViewController = PopoverViewController()

    @objc func showPopover(_ sender: UIButton) {
        popoverViewController.modalPresentationStyle = .popover

        let popoverPresentationController = popoverViewController.popoverPresentationController
        popoverPresentationController?.permittedArrowDirections = .up
        popoverPresentationController?.sourceRect = sender.bounds
        popoverPresentationController?.sourceView = sender
        popoverPresentationController?.delegate = self

        if let presentedViewController {
            presentedViewController.dismiss(animated: true) { [weak self] in
                guard let `self` else { return }
                self.present(self.popoverViewController, animated: true)
            }
         } else {
            present(popoverViewController, animated: true)
         }
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(button)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
        return .none
    }
}

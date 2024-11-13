//
//  PopoverViewController.swift
//  UIKit_Marathon_5
//
//  Created by @Lfgdsa on 11/13/24. 
//  Copyright (c) 2024 Eugene Babenko.
//

import UIKit

class PopoverViewController: UIViewController {

    private static let staticPopoverWidth: CGFloat = 300

    private enum ScreenHeight: Int, CaseIterable {
        case height280 = 0
        case height150 = 1

        var sizeString: String {
            switch self {
            case .height280:
                "280"
            case .height150:
                "150"
            }
        }

        var height: Int {
            switch self {
            case .height280:
                280
            case .height150:
                150
            }
        }
    }

    private let segmentedControl: UISegmentedControl = {
        let items = ScreenHeight.allCases.map(\.sizeString)
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private lazy var dismissButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark.circle.fill")?
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        config.imagePlacement = .all
        config.imagePadding = 0
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let button = UIButton(configuration: config)
        button.addAction(dismissAction(), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private var selectedSize: ScreenHeight = .height280 {
        didSet {
            setHeight()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        setupViews()
        setupConstraints()
        setupActions()
    }

    private func setupViews() {
        view.addSubview(segmentedControl)
        view.addSubview(dismissButton)
        preferredContentSize = CGSize(
            width: PopoverViewController.staticPopoverWidth,
            height: CGFloat(selectedSize.height)
        )
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            segmentedControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            segmentedControl.widthAnchor.constraint(equalToConstant: 100),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),

            dismissButton.centerYAnchor.constraint(equalTo: segmentedControl.centerYAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            dismissButton.heightAnchor.constraint(equalTo: segmentedControl.heightAnchor),
            dismissButton.widthAnchor.constraint(equalTo: dismissButton.heightAnchor)
        ])
    }

    private func setupActions() {
        segmentedControl.addTarget(
            self,
            action: #selector(segmentedControlValueChanged),
            for: .valueChanged
        )
    }

    @objc
    private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        guard let screenHeight = ScreenHeight(rawValue: sender.selectedSegmentIndex) else { return }
        selectedSize = screenHeight
    }

    private func dismissAction() -> UIAction {
        UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }

    private func setHeight() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut, .beginFromCurrentState],
            animations: { [weak self] in
                guard let `self` = self else { return }
                self.preferredContentSize = CGSize(
                    width: PopoverViewController.staticPopoverWidth,
                    height: CGFloat(self.selectedSize.height)
                )
            },
            completion: { _ in
                print("Height animation completed")
            }
        )
    }
}


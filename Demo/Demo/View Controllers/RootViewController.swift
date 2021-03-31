//
//  RootViewController.swift
//  HeaderTransitionKit_Example
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

final class RootViewController: UIViewController {

    // MARK: - Members

    private(set) lazy var pushButton: UIButton = {
        UIButton(type: .system, primaryAction: makePushButtonPrimaryAction())
    }()

    private(set) lazy var presentButton: UIButton = {
        UIButton(type: .system, primaryAction: makePresentButtonPrimaryAction())
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationControllerAppearance()
        configureHierarchy()
    }
}

// MARK: - Helpers

private extension RootViewController {

    func configureNavigationControllerAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()

        navigationBarAppearance.configureWithDefaultBackground()

        let transparentNavigationBarAppearance = navigationBarAppearance.copy()

        transparentNavigationBarAppearance.configureWithTransparentBackground()

        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = transparentNavigationBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureHierarchy() {
        navigationItem.title = "Root"
        navigationItem.largeTitleDisplayMode = .always

        view.backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [
            pushButton,
            presentButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor)
        ])
    }

    func makePushButtonPrimaryAction() -> UIAction? {
        return UIAction(title: "Push VC") { [unowned self] _ in
            let viewController = CollectionExampleViewController()

            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func makePresentButtonPrimaryAction() -> UIAction? {
        return UIAction(title: "Present VC") { [unowned self] _ in
            let viewController = CollectionExampleViewController()
            let navigationController = UINavigationController(rootViewController: viewController)

            present(navigationController, animated: true)
        }
    }
}

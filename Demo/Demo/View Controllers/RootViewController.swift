//
//  RootViewController.swift
//  HeaderTransitionKit_Example
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

final class RootViewController: UIViewController {

    // MARK: - Members

    private(set) lazy var collectionViewButtonItem: UIBarButtonItem = {
        UIBarButtonItem(title: "Collection View", primaryAction: makeCollectionViewButtonItemPrimaryAction())
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
        navigationItem.rightBarButtonItem = collectionViewButtonItem

        view.backgroundColor = .systemBackground
    }

    func makeCollectionViewButtonItemPrimaryAction() -> UIAction? {
        return UIAction { [unowned self] _ in
            let viewController = CollectionExampleViewController()

            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

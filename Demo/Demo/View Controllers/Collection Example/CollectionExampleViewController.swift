//
//  CollectionExampleViewController.swift
//  Demo
//
//  Created by Antoine Barré on 3/31/21.
//

import HeaderTransitionKit
import UIKit

final class CollectionExampleViewController: UIViewController, HTNavigationBarFadedTransitionContentProviding {

    enum Section {
        case main
    }

    // MARK: - Overrides

    var preferredNavigationBarTintColor: UIColor {
        return .systemOrange
    }

    var preferredNavigationBarTitleTextAttributes: [NSAttributedString.Key: Any]? {
        return nil
    }

    var scrollView: UIScrollView {
        return collectionView
    }

    // MARK: - Members

    weak var coordinator: HTNavigationBarFadedTransitionCoordinator?

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!

    private(set) lazy var headerView: HTHeaderViewTransitioning = {
        HeaderView(navigationUnderlayHeight: navigationControllerHeight)
    }()

    private(set) lazy var overlay: HTHeaderViewOverlaying = {
        let view = OverlayView()

        view.backgroundColor = .clear

        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Collection View"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItems = [UIBarButtonItem(systemItem: .refresh)]

        configureHierarchy()
        configureDataSource()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        headerView.imageView.image = (headerView as? HeaderView)?.placeholderImage
    }

    func configureHierarchy() {
        print(view.bounds)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset.bottom = 34
        collectionView.delegate = self

        headerView.imageView.image = (headerView as? HeaderView)?.placeholderImage

        view.addSubview(collectionView)
    }
}

extension CollectionExampleViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at indexPath: \(indexPath)")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        coordinator?.animateTransition(in: scrollView)
    }
}

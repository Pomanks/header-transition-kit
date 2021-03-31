//
//  CollectionExampleViewController.swift
//  HeaderTransitionKit_Example
//
//  Created by Antoine Barré on 3/31/21.
//

import HeaderTransitionKit
import UIKit

final class CollectionExampleViewController: HTNavigationBarFadingViewController {

    enum Section {
        case main
    }

    // MARK: - Overrides

    override var scrollView: UIScrollView {
        return collectionView
    }

    override var headerViewTransitioning: HTHeaderViewTransitioning {
        return stretchyHeaderView
    }

    override var headerViewOverlaying: HTHeaderViewOverlaying {
        return overlayHeaderView
    }

    // MARK: - Members

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    var collectionView: UICollectionView!

    private(set) lazy var stretchyHeaderView: HTHeaderView = {
        HTHeaderView(navigationUnderlayHeight: navigationControllerHeight)
    }()

    private(set) lazy var overlayHeaderView: HTHeaderViewOverlay = {
        let view = HTHeaderViewOverlay()

        view.backgroundColor = .clear

        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Collection View"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItems = [UIBarButtonItem(systemItem: .refresh)]

        configureDataSource()
    }

    override func configureHierarchy() {
        super.configureHierarchy()

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset.bottom = 34
        collectionView.delegate = self

        view.addSubview(collectionView)
    }
}

extension CollectionExampleViewController: UICollectionViewDelegate {}

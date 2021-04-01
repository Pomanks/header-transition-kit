//
//  CollectionExampleViewController+Configuration.swift
//  Demo
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

extension CollectionExampleViewController {

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            [unowned self] collectionView, indexPath, identifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration(), for: indexPath, item: identifier)
        }
        dataSource.supplementaryViewProvider = supplementaryViewProvider()

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()

        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0 ..< 94))

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func cellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, Int> {
        return .init { cell, _, identifier in
            var background = UIBackgroundConfiguration.clear()
            var content = UIListContentConfiguration.cell()

            background.backgroundColor = .systemOrange

            content.text = "\(identifier)"
            content.textProperties.alignment = .center
            content.textProperties.font = .preferredFont(forTextStyle: .title1)

            cell.backgroundConfiguration = background
            cell.contentConfiguration = content
        }
    }

    func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider())

        layout.register(
            SectionBackgroundDecorationView.self,
            forDecorationViewOfKind: SectionBackgroundDecorationView.elementKind
        )
        return layout
    }

    func sectionProvider() -> UICollectionViewCompositionalLayoutSectionProvider {
        return { _, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let numberOfItems = self.maximumNumberOfItems(for: layoutEnvironment, matching: 100)
            let ratio = layoutEnvironment.container.effectiveContentSize.width / CGFloat(numberOfItems)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(ratio)
            )
            let group: NSCollectionLayoutGroup = .horizontal(layoutSize: groupSize, subitem: item, count: numberOfItems)
            let section = NSCollectionLayoutSection(group: group)

            section.decorationItems = [.background(elementKind: SectionBackgroundDecorationView.elementKind)]

            return section
        }
    }

    func supplementaryViewProvider() -> UICollectionViewDiffableDataSource<Section, Int>.SupplementaryViewProvider? {
        return { collectionView, kind, indexPath in
            switch kind {
            case SectionBackgroundDecorationView.elementKind:
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: kind,
                    for: indexPath
                )

            default:
                return nil
            }
        }
    }
}

// MARK: - Helpers

private extension CollectionExampleViewController {

    func maximumNumberOfItems(for layoutEnvironment: NSCollectionLayoutEnvironment, matching minWidth: CGFloat) -> Int {
        let width = layoutEnvironment.container.effectiveContentSize.width
        let maxNumberOfItems = (width / minWidth).rounded(.toNearestOrEven)

        return Int(maxNumberOfItems)
    }
}

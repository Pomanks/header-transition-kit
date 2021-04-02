//
//  OverlayView.swift
//  Demo
//
//  Created by Antoine Barré on 4/2/21.
//

import HeaderTransitionKit
import UIKit

final class OverlayView: HTHeaderViewOverlay {

    // MARK: - Members

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 2
        label.text = "San francisco"

        return label
    }()

    override func configureHierarchy() {
        super.configureHierarchy()

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
}

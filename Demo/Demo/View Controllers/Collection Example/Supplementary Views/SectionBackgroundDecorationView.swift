//
//  SectionBackgroundDecorationView.swift
//  Demo
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

final class SectionBackgroundDecorationView: UICollectionReusableView {

    static let elementKind: String = "SectionBackgroundDecorationViewElementKind"

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SectionBackgroundDecorationView {

    func configureHierarchy() {
        backgroundColor = .systemBackground
    }
}

//
//  HTHeaderViewOverlay.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

open class HTHeaderViewOverlay: UIView {

    // MARK: - Members

    private(set) lazy var maskGradientView: HTGradientView = {
        let view = HTGradientView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.configureDefaultBackground()

        return view
    }()

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 2
        label.text = "San francisco"
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers

private extension HTHeaderViewOverlay {

    func configureHierarchy() {
        insetsLayoutMarginsFromSafeArea = false
        overrideUserInterfaceStyle = .dark
        preservesSuperviewLayoutMargins = true

        addSubview(maskGradientView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            maskGradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            maskGradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            maskGradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            maskGradientView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 4 / 7),

            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
}

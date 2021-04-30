//
//  HTGradientView.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

open class HTGradientView: UIView {

    // MARK: - Overrides

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    // MARK: - Initializers

    override public init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    func configureDefaultBackground(locations: [NSNumber]? = nil) {
        let colors: [UIColor] = [
            .clear,
            .darkGray
        ]
        configureGradient(with: colors, locations: locations)
    }

    func configureNavigationBackground() {
        let colors: [UIColor] = [
            .black.withAlphaComponent(0.7),
            .clear
        ]
        configureGradient(with: colors, locations: nil)
    }

    func configure(with colors: [UIColor], locations: [NSNumber]? = nil) {
        configureGradient(with: colors, locations: locations)
    }
}

// MARK: - Helpers

private extension HTGradientView {

    func configureGradient(with colors: [UIColor], locations: [NSNumber]?) {
        guard let layer = layer as? CAGradientLayer else {
            return
        }
        layer.colors = colors.map { $0.cgColor }
        layer.locations = locations
    }
}

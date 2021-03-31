//
//  HTHeaderView.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

open class HTHeaderView: UIView {

    // MARK: - Members

    var placeholderImage: UIImage? {
        switch (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {
        case (.compact, .regular):
            return UIImage(named: "background-portrait")

        default:
            return UIImage(named: "background-landscape")
        }
    }

    open var multiplier: CGFloat {
        let width = placeholderImage?.size.width ?? 1
        let height = placeholderImage?.size.height ?? 1

        return 1 / (width / height)
    }

    public private(set) lazy var navigationUnderlayGradientView: HTGradientView = {
        let view = HTGradientView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.configureNavigationBackground()

        return view
    }()

    public private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: placeholderImage)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill // This is required for the stretchy effect
        imageView.clipsToBounds = true

        return imageView
    }()

    public private(set) lazy var visualEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: effect)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = .zero

        return view
    }()

    // MARK: - Initializers

    let navigationUnderlayHeight: CGFloat

    public convenience init(navigationUnderlayHeight: CGFloat) {
        self.init(frame: .zero, navigationUnderlayHeight: navigationUnderlayHeight)
    }

    public init(frame: CGRect, navigationUnderlayHeight: CGFloat) {
        self.navigationUnderlayHeight = navigationUnderlayHeight

        super.init(frame: frame)

        configureHierarchy()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    //    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    //        super.traitCollectionDidChange(previousTraitCollection)
    //
    //        imageView.image = placeholderImage
    //    }
}

// MARK: - Helpers

private extension HTHeaderView {

    func configureHierarchy() {
        preservesSuperviewLayoutMargins = true

        backgroundColor = UIColor(white: 1, alpha: 0.2)

        addSubview(imageView)
        addSubview(navigationUnderlayGradientView)
        addSubview(visualEffectView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            navigationUnderlayGradientView.topAnchor.constraint(equalTo: topAnchor),
            navigationUnderlayGradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationUnderlayGradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationUnderlayGradientView.heightAnchor.constraint(equalToConstant: navigationUnderlayHeight),

            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

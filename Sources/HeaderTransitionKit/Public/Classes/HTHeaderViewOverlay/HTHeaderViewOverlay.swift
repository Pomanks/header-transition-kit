//
//  HTHeaderViewOverlay.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

open class HTHeaderViewOverlay: UIView {

    // MARK: - Members

    /// The preferred interface applied to the whole view hierarchy. The default value is `.dark`.
    open var preferredUserInterfaceStyle: UIUserInterfaceStyle {
        return .dark
    }

    /// Applies to the gradient mask's height constraint. The default value is `1`.
    open var multiplier: CGFloat {
        return 1
    }

    public private(set) lazy var maskGradientView: HTGradientView = {
        let view = HTGradientView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.configureDefaultBackground()

        return view
    }()

    // MARK: - Initializers

    override public init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    open func setColors(to colors: [UIColor],
                        updatingUserInterfaceStyleTo newUserInterfaceStyle: UIUserInterfaceStyle? = nil) {

        if let newUserInterfaceStyle = newUserInterfaceStyle {
            overrideUserInterfaceStyle = newUserInterfaceStyle
        }
        maskGradientView.configure(with: colors)
    }

    open func configureHierarchy() {
        insetsLayoutMarginsFromSafeArea = false
        overrideUserInterfaceStyle = preferredUserInterfaceStyle
        preservesSuperviewLayoutMargins = true

        addSubview(maskGradientView)

        NSLayoutConstraint.activate([
            maskGradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            maskGradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            maskGradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            maskGradientView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier)
        ])
    }
}

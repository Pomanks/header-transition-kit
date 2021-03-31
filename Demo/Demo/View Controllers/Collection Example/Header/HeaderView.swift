//
//  HeaderView.swift
//  Demo
//
//  Created by Antoine Barré on 3/31/21.
//

import HeaderTransitionKit
import UIKit

final class HeaderView: HTHeaderView {

    var placeholderImage: UIImage? {
        switch (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {
        case (.compact, .regular):
            return UIImage(named: "background-portrait")

        default:
            return UIImage(named: "background-landscape")
        }
    }

    override var multiplier: CGFloat {
        let width = placeholderImage?.size.width ?? 1
        let height = placeholderImage?.size.height ?? 1

        return 1 / (width / height)
    }
}

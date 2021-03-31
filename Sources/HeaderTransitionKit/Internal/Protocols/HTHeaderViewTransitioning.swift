//
//  HTHeaderViewTransitioning.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

public protocol HTHeaderViewTransitioning: UIView {

    var multiplier: CGFloat { get }
    var navigationUnderlayGradientView: HTGradientView { get }
    var imageView: UIImageView { get }
    var visualEffectView: UIVisualEffectView { get }
}

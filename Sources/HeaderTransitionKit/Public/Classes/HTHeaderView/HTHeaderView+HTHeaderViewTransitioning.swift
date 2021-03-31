//
//  HTHeaderView+HTHeaderViewTransitioning.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

extension HTHeaderView: HTHeaderViewTransitioning {

    open func updateImage() {
        imageView.image = placeholderImage
    }
}

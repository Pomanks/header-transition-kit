//
//  CGFloat+Helpers.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import CoreGraphics

extension CGFloat {

    static func fractionComplete(from value: CGFloat) -> Self {
        return Swift.max(.zero, Swift.min(value, 1.0))
    }

    static func oneThird(of value: CGFloat) -> Self {
        return value / CGFloat(3)
    }

    static func twoThirds(of value: CGFloat) -> Self {
        return value - .oneThird(of: value)
    }
}

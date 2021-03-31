//
//  UIColor+Helpers.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

// MARK: - UIColor + HSBA

extension UIColor {

    struct HSBA {
        var hue: CGFloat = .zero
        var saturation: CGFloat = .zero
        var brightness: CGFloat = .zero
        var alpha: CGFloat = .zero
    }

    var hsba: HSBA {
        var hsba = HSBA()

        getHue(&hsba.hue, saturation: &hsba.saturation, brightness: &hsba.brightness, alpha: &hsba.alpha)

        return hsba
    }

    func withSaturationUpdated(to newValue: CGFloat) -> UIColor {
        var hsba = hsba

        hsba.saturation = newValue

        return UIColor(hsba: hsba)
    }
}

// MARK: - UIColor + Init

extension UIColor {

    convenience init(hsba: HSBA) {
        self.init(hue: hsba.hue, saturation: hsba.saturation, brightness: hsba.brightness, alpha: hsba.alpha)
    }
}

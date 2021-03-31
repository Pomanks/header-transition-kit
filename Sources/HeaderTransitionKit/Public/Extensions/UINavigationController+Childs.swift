//
//  UINavigationController+Childs.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

public extension UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
}

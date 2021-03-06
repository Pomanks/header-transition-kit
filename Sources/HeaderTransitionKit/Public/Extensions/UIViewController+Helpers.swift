//
//  UIViewController+Helpers.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

public extension UIViewController {

    var statusBarManager: UIStatusBarManager? {
        return view.window?.windowScene?.statusBarManager
    }

    var statusBarFrame: CGRect {
        return statusBarManager?.statusBarFrame ?? .zero
    }

    var statusBarHeight: CGFloat {
        return isPresented ? .zero : statusBarFrame.height
    }

    var navigationBarHeight: CGFloat {
        return navigationController?.navigationBar.frame.height ?? .zero
    }

    var navigationControllerHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }

    var isPresented: Bool {
        return presentingViewController != nil
            || navigationController?.presentingViewController?.presentedViewController == navigationController
            || tabBarController?.presentingViewController is UITabBarController
    }
}

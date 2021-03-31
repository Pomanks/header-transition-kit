//
//  HTNavigationBarFadingViewController.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

open class HTNavigationBarFadingViewController: UIViewController {

    // MARK: - Overrides

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    // MARK: - Members

    open var barStyle: UIBarStyle = .default {
        didSet {
            statusBarStyle = barStyle == .black ? .lightContent : .default
        }
    }

    open var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    open var preferredTitleTextAttributes: [NSAttributedString.Key: Any] {
        return [:]
    }

    open var scrollView: UIScrollView {
        fatalError("You need to specify some `UIScrollView` for the transition! If your scroll view requires some configuration up-front, please use `configureHierarchy()`")
    }

    open var headerViewTransitioning: HTHeaderViewTransitioning {
        fatalError("You need to specify some `UIView` for the transition!")
    }

    open var headerViewOverlaying: HTHeaderViewOverlaying {
        fatalError("You need to specify some `UIView` for the transition!")
    }

    open var navigationBarPreferredTintColor: UIColor {
        fatalError("You need to specify some `UIColor` for the transition!")
    }

    var animator: UIViewPropertyAnimator?
    var headerTopConstraint: NSLayoutConstraint!
    var headerHeightConstraint: NSLayoutConstraint!
    var overlayBottomConstraint: NSLayoutConstraint!
    var overlayHeightConstraint: NSLayoutConstraint!

    // MARK: - Lifecycle

    override open func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureScrollViewHierarchy()
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollViewWillLayoutSubviews()
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        scrollViewWillTransition(to: size, with: coordinator)
    }

    /**
     - Tag: configureHierarchy()

     This method is called before `configureScrollViewHierarchy()` and relies on your `UIViewController` having a valid and configured `UIScrollView`.

     - Remark:  You should override this method to implement your hierarchy logic, setup your scrollView ,…
     */
    open func configureHierarchy() {}
}

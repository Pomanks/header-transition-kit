//
//  HTNavigationBarFading.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

protocol HTNavigationBarFading: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView { get }
    var headerViewTransitioning: HTHeaderViewTransitioning { get }
    var headerViewOverlaying: HTHeaderViewOverlaying { get }

    var animator: UIViewPropertyAnimator? { get set }
    var headerTopConstraint: NSLayoutConstraint! { get set }
    var headerHeightConstraint: NSLayoutConstraint! { get set }
    var overlayBottomConstraint: NSLayoutConstraint! { get set }
    var overlayHeightConstraint: NSLayoutConstraint! { get set }

    func configureScrollViewHierarchy()
    func scrollViewWillLayoutSubviews()
    func scrollViewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    func scrollViewDidPerformTransition()
}

// MARK: - Helpers

extension HTNavigationBarFading {

    var headerHeight: CGFloat {
        return view.bounds.width * headerViewTransitioning.multiplier
    }

    var heightConstant: CGFloat {
        return headerHeightConstraint.constant
    }

    var contentOffset: CGPoint {
        return scrollView.contentOffset
    }

    var adjustedContentOffset: CGPoint {
        var contentOffset = contentOffset

        contentOffset.y += scrollView.safeAreaInsets.top

        return contentOffset
    }

    func updateNavigationBarAppearance(with textAttributes: [NSAttributedString.Key: Any]? = nil) {
        let navigationBarAppearance = UINavigationBarAppearance()

        navigationBarAppearance.titleTextAttributes = textAttributes ?? [
            .font: .preferredFont(forTextStyle: .headline) as UIFont,
            .foregroundColor: .label as UIColor
        ]
        if -contentOffset.y < navigationControllerHeight {
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.shadowColor = nil
            navigationBarAppearance.shadowImage = nil

            navigationController?.navigationBar.tintColor = .systemOrange
        } else {
            navigationBarAppearance.configureWithTransparentBackground()
        }
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
    }

    func updateScrollView(for size: CGSize? = nil) {
        let newHeight = (calculateHeight(from: size) ?? heightConstant)
        let newConstant = newHeight - scrollView.safeAreaInsets.top
        let newContentOffset = CGPoint(x: .zero, y: -newHeight)

        scrollView.contentInset.top = newConstant
        scrollView.verticalScrollIndicatorInsets.top = newConstant
        scrollView.setContentOffset(newContentOffset, animated: true)
    }

    func updateTransitioningViews(with size: CGSize? = nil) {
        updateHeaderConstraints(with: size)
        updateOverlayHeightConstraint(with: size)
    }

    func updateHeaderConstraints(with size: CGSize? = nil) {
        let currentHeight = headerHeight
        let newConstant = calculateHeight(from: size) ?? -adjustedContentOffset.y
        let relativeVerticalOffset = currentHeight - newConstant - scrollView.safeAreaInsets.top

        if -relativeVerticalOffset < .zero {
            let additionalOffset = (relativeVerticalOffset / currentHeight) * 65

            headerTopConstraint.constant = -newConstant - additionalOffset - scrollView.safeAreaInsets.top

        } else {
            let newHeight = newConstant + scrollView.safeAreaInsets.top

            headerHeightConstraint.constant = newHeight
            headerTopConstraint.constant = -newHeight
        }
    }

    func updateOverlayHeightConstraint(with size: CGSize? = nil) {
        if let newConstant = calculateHeight(from: size) {
            overlayHeightConstraint.constant = newConstant + scrollView.safeAreaInsets.top
        }
    }

    // MARK: Transition (Part 1)

    func performFirstTransition(after threshold: CGFloat) {
        let alpha: CGFloat = 1 - calculateAlpha(for: threshold)

        headerViewTransitioning.navigationUnderlayGradientView.alpha = alpha
    }

    func updateNavigationBarTintColorAlpha(with alpha: CGFloat) {
        let tintColor: UIColor = alpha == .zero ? .white : .systemOrange.withSaturationUpdated(to: alpha)

        navigationController?.navigationBar.tintColor = tintColor
    }

    // MARK: Transition (Part 2)

    func performSecondTransition(after threshold: CGFloat) {
        let alpha: CGFloat = calculateAlpha(for: threshold)
        let reversedAlpha = 1 - alpha

        headerViewTransitioning.imageView.alpha = reversedAlpha
        headerViewTransitioning.visualEffectView.alpha = alpha

        headerViewOverlaying.alpha = reversedAlpha

        updateStatusBarStyle(with: alpha)
        updateNavigationBarTintColorAlpha(with: alpha)
        updateNavigationItemAlpha(to: alpha)
    }

    func updateStatusBarStyle(with fractionComplete: CGFloat) {
        animator?.addAnimations { [weak self] in
            //            self?.rootViewController?.statusBarStyle = fractionComplete >= 0.5 ?  : .lightContent
        }
        animator?.fractionComplete = fractionComplete
    }

    func updateNavigationItemAlpha(to alpha: CGFloat) {
        navigationItem.titleView?.alpha = alpha
    }

    func calculateAlpha(for threshold: CGFloat) -> CGFloat {
        let delta: CGFloat = 26 + navigationControllerHeight // Matches half the Large Title extra space
        //        let threshold: CGFloat = .oneThird(of: headerHeight) // The point where our transition will start
        let effectiveNavigationOffsetY = threshold + delta + contentOffset.y // The offset matching our navigation's height

        return .fractionComplete(from: effectiveNavigationOffsetY / threshold)
    }

    func calculateHeight(from size: CGSize?) -> CGFloat? {
        guard let size = size else {
            return nil
        }
        return size.width * headerViewTransitioning.multiplier
    }
}

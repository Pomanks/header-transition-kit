//
//  HTNavigationBarFadedTransitionController+HTNavigationBarFading.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

extension HTNavigationBarFadedTransitionController: HTNavigationBarFading, HTStatusBarUpdating {

    open var preferredNavigationBarTintColor: UIColor {
        rootViewController.preferredNavigationBarTintColor
    }

    open var preferredNavigationBarTitleTextAttributes: [NSAttributedString.Key: Any]? {
        return rootViewController.preferredNavigationBarTitleTextAttributes
    }

    open var scrollView: UIScrollView {
        rootViewController.scrollView
    }

    open var headerView: HTHeaderViewTransitioning {
        rootViewController.headerView
    }

    open var overlay: HTHeaderViewOverlaying {
        rootViewController.overlay
    }

    func configureNavigationBarAppearance(with alpha: CGFloat = .zero) {
        guard let navigationController = navigationController else {
            return
        }
        let navigationBarAppearance = UINavigationBarAppearance()
        let color: UIColor?
        var attributes = preferredNavigationBarTitleTextAttributes ?? navigationBarAppearance.titleTextAttributes

        color = attributes[.foregroundColor] as? UIColor

        if -contentOffset.y < navigationControllerHeight {
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.shadowColor = nil
            navigationBarAppearance.shadowImage = nil

            navigationController.navigationBar.tintColor = preferredNavigationBarTintColor

        } else {
            navigationBarAppearance.configureWithTransparentBackground()
        }
        attributes[.foregroundColor] = color?.withAlphaComponent(alpha)

        navigationBarAppearance.titleTextAttributes = attributes

        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
    }

    /**
     Updates both `contentInset.top` and `adjustedContentOffset` of your `scrollView` to match you `view`'s `width`.
     This will also ensure you header's constraints (`heightAnchor` / `topAnchor`) are updated with the correct values.

     This method should be called inside `viewWillLayoutSubviews()`.
     */
    func layoutSubviews() {
        guard headerHeightConstraint.constant == .zero, overlayHeightConstraint.constant == .zero else {
            return
        }
        let constant = headerHeight

        headerHeightConstraint.constant = constant
        overlayHeightConstraint.constant = constant

        configureScrollView()
        configureConstraints()
        configureSubviews()
    }

    /**
     Ensures the `transitionView` still fits your requirements and adapts to any new size.

     This method should be called inside `viewWillTransition(to:, with:)`.

     - Parameters:
         - size:         The new size for the container’s view.
         - coordinator:  The transition coordinator object managing the size change. You can use this object to animate your changes or get information about the transition that is in progress.
     */
    func transition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.configureScrollView(for: size)
            self?.configureConstraints(for: size)
        })
    }

    /**
     This method performs all the transition logic.

     This method should be called inside `scrollViewDidScroll(_:)`.
     */
    func scrollViewDidPerformTransition() {
        let currentHeight = headerHeight
        let step1Completion = fractionComplete(after: .twoThirds(of: currentHeight))
        let step2Completion = fractionComplete(after: .oneThird(of: currentHeight))
        let finalFraction = fractionComplete(after: navigationControllerHeight, delta: 52)

        configureConstraints()

        // Step 1
        headerView.navigationUnderlayGradientView.alpha = 1 - step1Completion

        // Step 2
        headerView.imageView.alpha = 1 - step2Completion
        headerView.visualEffectView.alpha = step2Completion

        overlay.alpha = 1 - step2Completion

        updateNavigationBarTintColorAlpha(with: step2Completion)

        // - Step 3
        if !isPresented {
            updateStatusBarStyle(for: finalFraction)
        }
        configureNavigationBarAppearance(with: finalFraction)
    }
}

// MARK: - Animations / Transitions

private extension HTNavigationBarFadedTransitionController {

    func fractionComplete(after threshold: CGFloat, delta value: CGFloat? = nil) -> CGFloat {
        let delta = (value ?? 26) + navigationControllerHeight // Matches half the Large Title extra space
        let effectiveNavigationOffsetY = threshold + delta + contentOffset.y // The offset matching our navigation's height

        return .fractionComplete(from: effectiveNavigationOffsetY / threshold)
    }

    func height(from size: CGSize?) -> CGFloat? {
        guard let size = size else {
            return nil
        }
        return size.width * headerView.multiplier
    }

    func configureScrollView(for size: CGSize? = nil) {
        let height = height(from: size) ?? headerHeightConstraint.constant
        let topInset = height - scrollView.safeAreaInsets.top
        let contentOffset = CGPoint(x: .zero, y: -height)

        scrollView.contentInset.top = topInset
        scrollView.verticalScrollIndicatorInsets.top = topInset
        scrollView.setContentOffset(contentOffset, animated: true)
    }

    func configureConstraints(for size: CGSize? = nil) {
        let currentHeight = headerHeight
        let constant = height(from: size)
        let headerConstant = (constant ?? -adjustedContentOffset.y) + scrollView.safeAreaInsets.top
        let relativeVerticalOffset = currentHeight - headerConstant

        if -relativeVerticalOffset < .zero {
            let delta = (relativeVerticalOffset / currentHeight) * 65

            headerTopConstraint.constant = -headerConstant - delta

        } else {
            headerHeightConstraint.constant = headerConstant
            headerTopConstraint.constant = -headerConstant
        }
        guard let overlayConstant = constant else {
            return
        }
        overlayHeightConstraint.constant = overlayConstant + scrollView.safeAreaInsets.top
    }

    func configureSubviews() {
        let alpha: CGFloat = .zero

        updateStatusBarStyle(for: alpha)
    }

    func updateNavigationBarTintColorAlpha(with alpha: CGFloat) {
        let tintColor: UIColor = alpha == .zero
            ? .white
            : preferredNavigationBarTintColor.withSaturationUpdated(to: alpha)

        navigationController?.navigationBar.tintColor = tintColor
    }

    func updateStatusBarStyle(for value: CGFloat) {
        barStyle = value >= 0.5 ? .default : .black
    }
}

// MARK: - Helpers

private extension HTNavigationBarFadedTransitionController {

    var headerHeight: CGFloat {
        return view.bounds.width * headerView.multiplier
    }

    var contentOffset: CGPoint {
        return scrollView.contentOffset
    }

    var adjustedContentOffset: CGPoint {
        var contentOffset = contentOffset

        contentOffset.y += scrollView.safeAreaInsets.top

        return contentOffset
    }
}

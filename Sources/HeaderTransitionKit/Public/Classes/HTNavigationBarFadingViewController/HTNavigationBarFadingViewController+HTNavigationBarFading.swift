//
//  HTNavigationBarFadingViewController+HTNavigationBarFading.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

extension HTNavigationBarFadingViewController: HTNavigationBarFading {

    func configureScrollViewHierarchy() {
        headerViewTransitioning.layer.zPosition = -1
        headerViewTransitioning.translatesAutoresizingMaskIntoConstraints = false

        headerViewOverlaying.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(headerViewTransitioning)
        scrollView.addSubview(headerViewOverlaying)

        animator = UIViewPropertyAnimator()
        animator?.startAnimation()
        animator?.pauseAnimation()

        // Constants are set later…
        headerTopConstraint = headerViewTransitioning.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor)
        overlayBottomConstraint = headerViewOverlaying.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor)

        NSLayoutConstraint.activate([
            headerTopConstraint,

            headerViewTransitioning.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            headerViewTransitioning.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),

            headerViewOverlaying.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            headerViewOverlaying.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),

            overlayBottomConstraint
        ])
    }

    /**
     Updates both `contentInset.top` and `adjustedContentOffset` of your `scrollView` to match you `view`'s `width`.
     This will also ensure you header's constraints (`heightAnchor` / `topAnchor`) are updated with the correct values.

     This method should be called inside `viewWillLayoutSubviews()`.
     */
    func scrollViewWillLayoutSubviews() {
        guard headerHeightConstraint == nil, overlayHeightConstraint == nil else {
            return
        }
        let effectiveHeight = headerHeight

        headerHeightConstraint = headerViewTransitioning.heightAnchor.constraint(equalToConstant: effectiveHeight)
        headerHeightConstraint.priority = .init(rawValue: 999)

        overlayHeightConstraint = headerViewOverlaying.heightAnchor.constraint(equalToConstant: effectiveHeight)

        NSLayoutConstraint.activate([
            headerHeightConstraint,
            overlayHeightConstraint
        ])
        configureScrollView()
        configureConstraints()
    }

    /**
     Ensures the `transitionView` still fits your requirements and adapts to any new size.

     This method should be called inside `viewWillTransition(to:, with:)`.

     - Parameters:
         - size:         The new size for the container’s view.
         - coordinator:  The transition coordinator object managing the size change. You can use this object to animate your changes or get information about the transition that is in progress.
     */
    func scrollViewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.configureScrollView(for: size)
            self?.configureConstraints(with: size)
        })
    }

    /**
     This method performs all the transition logic.

     This method should be called inside `scrollViewDidScroll(_:)`.
     */
    func scrollViewDidPerformTransition() {
        let currentHeight = headerHeight
        let threshold = navigationControllerHeight + 52

        configureNavigationController()
        configureConstraints()

        performFirstTransition(after: .twoThirds(of: currentHeight))
        performSecondTransition(after: .oneThird(of: currentHeight))
        performThirdTransition(after: threshold)
    }
}

// MARK: - Helpers

private extension HTNavigationBarFadingViewController {

    func configureNavigationController() {
        guard let navigationController = navigationController else {
            return
        }
        let navigationBarAppearance = UINavigationBarAppearance()

        if !preferredTitleTextAttributes.isEmpty {
            navigationBarAppearance.titleTextAttributes = preferredTitleTextAttributes
        }
        if -contentOffset.y < navigationControllerHeight {
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.shadowColor = nil
            navigationBarAppearance.shadowImage = nil

            navigationController.navigationBar.tintColor = navigationBarPreferredTintColor

        } else {
            navigationBarAppearance.configureWithTransparentBackground()
        }
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
    }

    func configureScrollView(for size: CGSize? = nil) {
        let height = height(from: size) ?? headerHeightConstraint.constant
        let topInset = height - scrollView.safeAreaInsets.top
        let contentOffset = CGPoint(x: .zero, y: -height)

        scrollView.contentInset.top = topInset
        scrollView.verticalScrollIndicatorInsets.top = topInset
        scrollView.setContentOffset(contentOffset, animated: true)
    }

    func configureConstraints(with size: CGSize? = nil) {
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

    // MARK: Transition (Part 1)

    func performFirstTransition(after threshold: CGFloat) {
        headerViewTransitioning.navigationUnderlayGradientView.alpha = 1 - alpha(for: threshold)
    }

    // MARK: Transition (Part 2)

    func performSecondTransition(after threshold: CGFloat) {
        let alpha: CGFloat = alpha(for: threshold)
        let reversedAlpha = 1 - alpha

        headerViewTransitioning.imageView.alpha = reversedAlpha
        headerViewTransitioning.visualEffectView.alpha = alpha

        headerViewOverlaying.alpha = reversedAlpha

        updateStatusBarStyle(with: alpha)
        updateNavigationBarTintColorAlpha(with: alpha)
    }

    func updateStatusBarStyle(with fractionComplete: CGFloat) {
        guard !isPresented else {
            return
        }
        animator?.addAnimations { [weak self] in
            self?.barStyle = fractionComplete >= 0.5 ? .default : .black
        }
        animator?.fractionComplete = fractionComplete
    }

    func updateNavigationBarTintColorAlpha(with alpha: CGFloat) {
        let tintColor: UIColor = alpha == .zero
            ? .white
            : navigationBarPreferredTintColor.withSaturationUpdated(to: alpha)

        navigationController?.navigationBar.tintColor = tintColor
    }

    // MARK: - Transition (Part 3)

    func performThirdTransition(after threshold: CGFloat) {
        let alpha: CGFloat = alpha(for: threshold, delta: 52)

        updateNavigationItemAlpha(to: alpha)
    }

    func updateNavigationItemAlpha(to alpha: CGFloat) {
        navigationItem.titleView?.alpha = alpha
    }
}

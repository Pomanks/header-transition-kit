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
        updateScrollView()
        updateTransitioningViews()
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
            self?.headerViewTransitioning.updateImage()
            self?.updateScrollView(for: size)
            self?.updateTransitioningViews(with: size)
        })
    }

    /**
     This method performs all the transition logic.

     This method should be called inside `scrollViewDidScroll(_:)`.
     */
    func scrollViewDidPerformTransition() {
        let currentHeight = headerHeight

        updateNavigationBarAppearance()
        updateTransitioningViews()

        performFirstTransition(after: .twoThirds(of: currentHeight))
        performSecondTransition(after: .oneThird(of: currentHeight))
    }
}

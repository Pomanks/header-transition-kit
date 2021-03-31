//
//  HTNavigationBarFading.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

protocol HTNavigationBarFading: UIViewController, HTStatusBarUpdating, UIScrollViewDelegate {

    var scrollView: UIScrollView { get }
    var headerViewTransitioning: HTHeaderViewTransitioning { get }
    var headerViewOverlaying: HTHeaderViewOverlaying { get }
    var navigationBarPreferredTintColor: UIColor { get }

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

    var contentOffset: CGPoint {
        return scrollView.contentOffset
    }

    var adjustedContentOffset: CGPoint {
        var contentOffset = contentOffset

        contentOffset.y += scrollView.safeAreaInsets.top

        return contentOffset
    }

    func alpha(for threshold: CGFloat, delta value: CGFloat? = nil) -> CGFloat {
        let delta = value ?? 26 + navigationControllerHeight // Matches half the Large Title extra space
        let effectiveNavigationOffsetY = threshold + delta + contentOffset.y // The offset matching our navigation's height

        return .fractionComplete(from: effectiveNavigationOffsetY / threshold)
    }

    func height(from size: CGSize?) -> CGFloat? {
        guard let size = size else {
            return nil
        }
        return size.width * headerViewTransitioning.multiplier
    }
}

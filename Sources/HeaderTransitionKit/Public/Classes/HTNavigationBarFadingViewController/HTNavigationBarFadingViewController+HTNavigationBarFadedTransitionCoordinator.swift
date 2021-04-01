//
//  HTNavigationBarFadedTransitionController+UIScrollViewDelegate.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

// MARK: - HTNavigationBarFadedTransitioningDelegate

extension HTNavigationBarFadedTransitionController: HTNavigationBarFadedTransitionCoordinator {

    public func animateTransition(in scrollView: UIScrollView) {
        scrollViewDidPerformTransition()
    }
}

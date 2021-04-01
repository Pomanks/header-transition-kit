//
//  HTNavigationBarFadedTransitionController+UIScrollViewDelegate.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

// MARK: - UIScrollViewDelegate

extension HTNavigationBarFadedTransitionController: UIScrollViewDelegate {

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidPerformTransition()
    }
}

//
//  HTNavigationBarFading.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

public protocol HTNavigationBarFading: UIViewController {

    var preferredNavigationBarTintColor: UIColor { get }
    var preferredNavigationBarTitleTextAttributes: [NSAttributedString.Key: Any]? { get }
    var scrollView: UIScrollView { get }
    var headerView: HTHeaderViewTransitioning { get }
    var overlay: HTHeaderViewOverlaying { get }
}

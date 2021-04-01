//
//  HTNavigationBarFadedTransitionController.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

open class HTNavigationBarFadedTransitionController: UIViewController {

    // MARK: - Overrides

    override open var navigationItem: UINavigationItem {
        return rootViewController.navigationItem
    }

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

    private(set) var animator: UIViewPropertyAnimator?
    private(set) var headerTopConstraint: NSLayoutConstraint!
    private(set) var overlayBottomConstraint: NSLayoutConstraint!
    private(set) var headerHeightConstraint: NSLayoutConstraint!
    private(set) var overlayHeightConstraint: NSLayoutConstraint!

    // MARK: - Initializers

    private(set) var rootViewController: HTNavigationBarFading

    public init(rootViewController: HTNavigationBarFading) {
        self.rootViewController = rootViewController

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override open func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        layoutSubviews()
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        transition(to: size, with: coordinator)
    }
}

// MARK: - Helpers

private extension HTNavigationBarFadedTransitionController {

    func configureHierarchy() {
        view.addSubview(rootViewController.view)
        addChild(rootViewController)
        rootViewController.didMove(toParent: self)

        headerView.layer.zPosition = -1
        headerView.translatesAutoresizingMaskIntoConstraints = false

        overlay.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(headerView)
        scrollView.addSubview(overlay)

        animator = UIViewPropertyAnimator()
        animator?.startAnimation()
        animator?.pauseAnimation()

        // Constants are updated later…
        headerTopConstraint = headerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor)
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: .zero)
        headerHeightConstraint.priority = .init(rawValue: 999)

        overlayBottomConstraint = overlay.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor)
        overlayHeightConstraint = overlay.heightAnchor.constraint(equalToConstant: .zero)

        NSLayoutConstraint.activate([
            headerTopConstraint,
            headerHeightConstraint,

            headerView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),

            overlay.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),

            overlayBottomConstraint,
            overlayHeightConstraint
        ])
        scrollView.delegate = self
    }
}
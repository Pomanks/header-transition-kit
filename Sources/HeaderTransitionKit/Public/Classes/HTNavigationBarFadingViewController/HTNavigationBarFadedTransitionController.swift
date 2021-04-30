//
//  HTNavigationBarFadedTransitionController.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

public protocol HTNavigationBarFadedTransitionCoordinator: HTNavigationBarFadedTransitionController {

    func animateTransition(in scrollView: UIScrollView)
}

public protocol HTNavigationBarFadedTransitionContentProviding: HTNavigationBarFading {

    var coordinator: HTNavigationBarFadedTransitionCoordinator? { get set }
}

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

    private(set) var headerTopConstraint: NSLayoutConstraint!
    private(set) var overlayBottomConstraint: NSLayoutConstraint!
    private(set) var headerHeightConstraint: NSLayoutConstraint!
    private(set) var overlayHeightConstraint: NSLayoutConstraint!
    private(set) var preservedNavigationBarTintColor: UIColor?

    // MARK: - Initializers

    public private(set) var rootViewController: HTNavigationBarFadedTransitionContentProviding

    public init(rootViewController: HTNavigationBarFadedTransitionContentProviding) {
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

        preservedNavigationBarTintColor = navigationController?.navigationBar.tintColor
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        layoutSubviews()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBarAppearance()
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        transition(to: size, with: coordinator)
    }

    override open func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)

        navigationController?.navigationBar.tintColor = preservedNavigationBarTintColor
    }
}

// MARK: - Helpers

private extension HTNavigationBarFadedTransitionController {

    func configureHierarchy() {
        view.preservesSuperviewLayoutMargins = true

        addChild(rootViewController)
        view.addSubview(rootViewController.view)

        rootViewController.view.preservesSuperviewLayoutMargins = true
        rootViewController.view.frame = view.bounds
        rootViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rootViewController.didMove(toParent: self)
        rootViewController.coordinator = self

        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.clipsToBounds = true
        headerView.layer.zPosition = -1

        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.clipsToBounds = true

        scrollView.addSubview(headerView)
        scrollView.addSubview(overlay)

        // Constants are updated later…
        headerTopConstraint = headerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor)
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: .zero)
        headerHeightConstraint.priority = .init(rawValue: 999)

        overlayBottomConstraint = overlay.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor)
        overlayHeightConstraint = overlay.heightAnchor.constraint(equalToConstant: .zero)

        NSLayoutConstraint.activate([
            headerTopConstraint,
            headerHeightConstraint,

            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            overlayBottomConstraint,
            overlayHeightConstraint
        ])
    }
}
